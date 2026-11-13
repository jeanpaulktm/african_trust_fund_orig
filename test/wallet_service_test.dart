import 'package:african/core/money/currency.dart';
import 'package:african/features/wallet/domain/models/transaction.dart';
import 'package:african/features/wallet/domain/services/wallet_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late WalletService wallet;

  setUp(() {
    wallet = WalletService(
      usdToCdfRate: 2800,
      initialBalances: {
        'alice': {Currency.usd: 1000, Currency.cdf: 0},
        'bob': {Currency.usd: 0, Currency.cdf: 0},
      },
    );
  });

  test('withdrawal debits amount plus one percent and records the fee', () {
    final transaction = wallet.withdraw(
      userId: 'alice',
      currency: Currency.usd,
      amount: 100,
    );

    expect(transaction.type, TransactionType.withdrawal);
    expect(transaction.fee, 1);
    expect(wallet.balanceFor('alice', Currency.usd).amount, 899);
  });

  test(
    'withdrawal rejects insufficient funds including fees without mutation',
    () {
      expect(
        () => wallet.withdraw(
          userId: 'alice',
          currency: Currency.usd,
          amount: 999,
        ),
        throwsA(isA<StateError>()),
      );
      expect(wallet.balanceFor('alice', Currency.usd).amount, 1000);
      expect(wallet.transactions, isEmpty);
    },
  );

  test('cross-currency transfer uses the current administrator rate', () {
    wallet.updateExchangeRate(3000);
    wallet.transfer(
      fromUserId: 'alice',
      toUserId: 'bob',
      fromCurrency: Currency.usd,
      toCurrency: Currency.cdf,
      amount: 10,
    );

    expect(wallet.balanceFor('alice', Currency.usd).amount, 990);
    expect(wallet.balanceFor('bob', Currency.cdf).amount, 30000);
    expect(wallet.transactions, hasLength(2));
    expect(wallet.transactions.first.type, TransactionType.transferIn);
  });

  test(
    'invalid exchange rate is rejected without replacing the current rate',
    () {
      expect(() => wallet.updateExchangeRate(0), throwsArgumentError);
      expect(wallet.usdToCdfRate, 2800);
    },
  );

  test('amounts below one cent are rejected instead of recording zero-value operations', () {
    expect(
      () => wallet.deposit(
        userId: 'alice',
        currency: Currency.usd,
        amount: 0.001,
      ),
      throwsArgumentError,
    );
    expect(wallet.transactions, isEmpty);
  });
}
