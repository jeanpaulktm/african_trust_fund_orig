import 'package:african/core/money/currency.dart';
import 'package:african/features/credit/domain/models/credit_request.dart';
import 'package:african/features/credit/domain/services/credit_service.dart';
import 'package:african/features/wallet/domain/models/transaction.dart';
import 'package:african/features/wallet/domain/services/wallet_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late WalletService wallet;

  setUp(() {
    wallet = WalletService(
      usdToCdfRate: 2800,
      initialBalances: {
        'client': {Currency.usd: 20},
      },
    );
  });

  test('unavailable password verification prevents disbursement', () async {
    final credit = CreditService(
      wallet: wallet,
      passwordVerifier: const UnavailablePasswordVerifier(),
    );
    final request = credit.request(
      userId: 'client',
      currency: Currency.usd,
      amount: 50,
    );

    final result = await credit.disburse(
      userId: 'client',
      requestId: request.id,
      password: 'not-stored',
    );

    expect(result, PasswordVerificationResult.unavailable);
    expect(wallet.balanceFor('client', Currency.usd).amount, 20);
    expect(wallet.transactions, isEmpty);
    expect(
      credit.requestsFor('client').single.status,
      CreditRequestStatus.pending,
    );
  });

  test(
    'verified password disburses once and records a loan transaction',
    () async {
      final credit = CreditService(
        wallet: wallet,
        passwordVerifier: const _AcceptingVerifier(),
      );
      final request = credit.request(
        userId: 'client',
        currency: Currency.usd,
        amount: 50,
      );

      final result = await credit.disburse(
        userId: 'client',
        requestId: request.id,
        password: 'verified-remotely',
      );

      expect(result, PasswordVerificationResult.verified);
      expect(wallet.balanceFor('client', Currency.usd).amount, 70);
      expect(wallet.transactions.single.type, TransactionType.loanDisbursement);
      expect(
        credit.requestsFor('client').single.status,
        CreditRequestStatus.disbursed,
      );
    },
  );

  test('verified repayments reduce the balance and close the credit', () async {
    final credit = CreditService(
      wallet: wallet,
      passwordVerifier: const _AcceptingVerifier(),
    );
    final request = credit.request(
      userId: 'client',
      currency: Currency.usd,
      amount: 50,
    );
    await credit.disburse(
      userId: 'client',
      requestId: request.id,
      password: 'verified-remotely',
    );

    await credit.repay(
      userId: 'client',
      requestId: request.id,
      amount: 15,
      password: 'verified-remotely',
    );
    expect(wallet.balanceFor('client', Currency.usd).amount, 55);
    expect(credit.requestsFor('client').single.outstandingAmount, 35);
    expect(
      credit.requestsFor('client').single.status,
      CreditRequestStatus.disbursed,
    );

    await credit.repay(
      userId: 'client',
      requestId: request.id,
      amount: 35,
      password: 'verified-remotely',
    );
    expect(wallet.balanceFor('client', Currency.usd).amount, 20);
    expect(
      credit.requestsFor('client').single.status,
      CreditRequestStatus.repaid,
    );
    expect(wallet.transactions.first.type, TransactionType.loanRepayment);
  });
}

class _AcceptingVerifier implements PasswordVerifier {
  const _AcceptingVerifier();

  @override
  Future<PasswordVerificationResult> verifyPassword({
    required String userId,
    required String password,
  }) async => PasswordVerificationResult.verified;
}
