import 'package:african/core/money/currency.dart';
import 'package:african/features/savings/domain/services/savings_service.dart';
import 'package:african/features/wallet/domain/models/transaction.dart';
import 'package:african/features/wallet/domain/services/wallet_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('investment debits wallet and accrues simple annual interest', () {
    final start = DateTime(2025, 1, 1);
    final wallet = WalletService(
      usdToCdfRate: 2800,
      initialBalances: {
        'client': {Currency.usd: 1000},
      },
    );
    final savings = SavingsService(
      wallet: wallet,
      annualInterestRate: 0.05,
      clock: () => start,
    );

    final investment = savings.invest(
      userId: 'client',
      currency: Currency.usd,
      amount: 100,
    );

    expect(wallet.balanceFor('client', Currency.usd).amount, 900);
    expect(wallet.transactions.single.type, TransactionType.savingsInvestment);
    expect(investment.interestAt(start.add(const Duration(days: 365))), 5);
    expect(investment.valueAt(start.add(const Duration(days: 365))), 105);
  });

  test(
    'investment rejects insufficient funds without creating a placement',
    () {
      final wallet = WalletService(
        usdToCdfRate: 2800,
        initialBalances: {
          'client': {Currency.usd: 10},
        },
      );
      final savings = SavingsService(wallet: wallet, annualInterestRate: 0.05);

      expect(
        () => savings.invest(
          userId: 'client',
          currency: Currency.usd,
          amount: 11,
        ),
        throwsA(isA<StateError>()),
      );
      expect(savings.investmentsFor('client'), isEmpty);
      expect(wallet.balanceFor('client', Currency.usd).amount, 10);
    },
  );
}
