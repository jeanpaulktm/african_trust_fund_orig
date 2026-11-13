import '../../../../core/money/currency.dart';

enum TransactionType {
  deposit,
  withdrawal,
  transferIn,
  transferOut,
  savingsInvestment,
  loanDisbursement,
  loanRepayment,
}

class Transaction {
  const Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.createdAt,
    this.fee = 0,
    this.counterparty,
    this.convertedAmount,
    this.convertedCurrency,
  });

  final String id;
  final String userId;
  final TransactionType type;
  final double amount;
  final Currency currency;
  final DateTime createdAt;
  final double fee;
  final String? counterparty;
  final double? convertedAmount;
  final Currency? convertedCurrency;
}
