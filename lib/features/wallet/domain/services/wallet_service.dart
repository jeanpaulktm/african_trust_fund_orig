import '../../../../core/money/currency.dart';
import '../models/solde.dart';
import '../models/transaction.dart';

class WalletService {
  WalletService({
    required double usdToCdfRate,
    required Map<String, Map<Currency, double>> initialBalances,
  }) : _usdToCdfRate = _validateRate(usdToCdfRate) {
    for (final entry in initialBalances.entries) {
      _accounts[entry.key] = {
        for (final balance in entry.value.entries)
          balance.key: _validateInitialBalance(balance.value),
      };
    }
  }

  static const double withdrawalFeeRate = 0.01;

  final Map<String, Map<Currency, double>> _accounts = {};
  final List<Transaction> _transactions = [];
  double _usdToCdfRate;
  int _nextTransactionId = 0;

  double get usdToCdfRate => _usdToCdfRate;
  List<Transaction> get transactions => List.unmodifiable(_transactions);

  Solde balanceFor(String userId, Currency currency) {
    final amount = _accounts[userId]?[currency] ?? 0;
    return Solde(amount: amount, currency: currency);
  }

  void updateExchangeRate(double rate) {
    _usdToCdfRate = _validateRate(rate);
  }

  Transaction deposit({
    required String userId,
    required Currency currency,
    required double amount,
  }) {
    _validateAmount(amount);
    final roundedAmount = _money(amount);
    final account = _accountFor(userId);
    account[currency] = _money((account[currency] ?? 0) + roundedAmount);

    return _record(
      userId: userId,
      type: TransactionType.deposit,
      amount: roundedAmount,
      currency: currency,
    );
  }

  Transaction withdraw({
    required String userId,
    required Currency currency,
    required double amount,
  }) {
    _validateAmount(amount);
    final roundedAmount = _money(amount);
    final fee = _money(roundedAmount * withdrawalFeeRate);
    final totalDebit = _money(roundedAmount + fee);
    final account = _accountFor(userId);
    final currentBalance = account[currency] ?? 0;
    if (totalDebit > currentBalance) {
      throw StateError(
        'Solde insuffisant : ${currency.format(totalDebit)} requis, '
        '${currency.format(currentBalance)} disponible.',
      );
    }

    account[currency] = _money(currentBalance - totalDebit);
    return _record(
      userId: userId,
      type: TransactionType.withdrawal,
      amount: roundedAmount,
      currency: currency,
      fee: fee,
    );
  }

  Transaction investInSavings({
    required String userId,
    required Currency currency,
    required double amount,
  }) {
    _validateAmount(amount);
    final roundedAmount = _money(amount);
    final account = _accountFor(userId);
    final balance = account[currency] ?? 0;
    if (roundedAmount > balance) {
      throw StateError('Solde insuffisant en ${currency.code}.');
    }

    account[currency] = _money(balance - roundedAmount);
    return _record(
      userId: userId,
      type: TransactionType.savingsInvestment,
      amount: roundedAmount,
      currency: currency,
    );
  }

  Transaction disburseLoan({
    required String userId,
    required Currency currency,
    required double amount,
  }) {
    _validateAmount(amount);
    final roundedAmount = _money(amount);
    final account = _accountFor(userId);
    account[currency] = _money((account[currency] ?? 0) + roundedAmount);
    return _record(
      userId: userId,
      type: TransactionType.loanDisbursement,
      amount: roundedAmount,
      currency: currency,
    );
  }

  Transaction repayLoan({
    required String userId,
    required Currency currency,
    required double amount,
  }) {
    _validateAmount(amount);
    final roundedAmount = _money(amount);
    final account = _accountFor(userId);
    final balance = account[currency] ?? 0;
    if (roundedAmount > balance) {
      throw StateError('Solde insuffisant en ${currency.code}.');
    }

    account[currency] = _money(balance - roundedAmount);
    return _record(
      userId: userId,
      type: TransactionType.loanRepayment,
      amount: roundedAmount,
      currency: currency,
    );
  }

  List<Transaction> transfer({
    required String fromUserId,
    required String toUserId,
    required Currency fromCurrency,
    required Currency toCurrency,
    required double amount,
  }) {
    _validateAmount(amount);
    if (fromUserId == toUserId) {
      throw ArgumentError('Le compte destinataire doit être différent.');
    }

    final sourceAmount = _money(amount);
    final destinationAmount = _convert(sourceAmount, fromCurrency, toCurrency);
    final source = _accountFor(fromUserId);
    final destination = _accountFor(toUserId);
    final sourceBalance = source[fromCurrency] ?? 0;
    if (sourceAmount > sourceBalance) {
      throw StateError('Solde insuffisant en ${fromCurrency.code}.');
    }

    // Validate before mutating either account so a transfer is all-or-nothing.
    final updatedSource = _money(sourceBalance - sourceAmount);
    final updatedDestination = _money(
      (destination[toCurrency] ?? 0) + destinationAmount,
    );
    source[fromCurrency] = updatedSource;
    destination[toCurrency] = updatedDestination;

    final outgoing = _record(
      userId: fromUserId,
      type: TransactionType.transferOut,
      amount: sourceAmount,
      currency: fromCurrency,
      counterparty: toUserId,
      convertedAmount: destinationAmount,
      convertedCurrency: toCurrency,
    );
    final incoming = _record(
      userId: toUserId,
      type: TransactionType.transferIn,
      amount: destinationAmount,
      currency: toCurrency,
      counterparty: fromUserId,
      convertedAmount: sourceAmount,
      convertedCurrency: fromCurrency,
    );
    return [outgoing, incoming];
  }

  double _convert(double amount, Currency from, Currency to) {
    if (from == to) return amount;
    final converted = from == Currency.usd
        ? amount * _usdToCdfRate
        : amount / _usdToCdfRate;
    final result = _money(converted);
    if (result <= 0) {
      throw ArgumentError('Le montant est trop faible après conversion.');
    }
    return result;
  }

  Map<Currency, double> _accountFor(String userId) {
    if (userId.trim().isEmpty) {
      throw ArgumentError.value(userId, 'userId', 'Identifiant obligatoire.');
    }
    return _accounts.putIfAbsent(userId, () => {});
  }

  Transaction _record({
    required String userId,
    required TransactionType type,
    required double amount,
    required Currency currency,
    double fee = 0,
    String? counterparty,
    double? convertedAmount,
    Currency? convertedCurrency,
  }) {
    final transaction = Transaction(
      id: 'txn-${++_nextTransactionId}',
      userId: userId,
      type: type,
      amount: amount,
      currency: currency,
      createdAt: DateTime.now(),
      fee: fee,
      counterparty: counterparty,
      convertedAmount: convertedAmount,
      convertedCurrency: convertedCurrency,
    );
    _transactions.insert(0, transaction);
    return transaction;
  }

  static double _money(double amount) => (amount * 100).roundToDouble() / 100;

  static void _validateAmount(double amount) {
    if (!amount.isFinite || amount <= 0 || _money(amount) <= 0) {
      throw ArgumentError.value(
        amount,
        'amount',
        'Le montant doit être au moins égal à 0,01.',
      );
    }
  }

  static double _validateInitialBalance(double amount) {
    if (!amount.isFinite || amount < 0) {
      throw ArgumentError.value(
        amount,
        'initialBalance',
        'Le solde initial doit être un nombre positif ou nul.',
      );
    }
    return _money(amount);
  }

  static double _validateRate(double rate) {
    if (!rate.isFinite || rate <= 0) {
      throw ArgumentError.value(
        rate,
        'usdToCdfRate',
        'Le taux doit être un nombre positif.',
      );
    }
    return rate;
  }
}
