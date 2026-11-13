import '../../../../core/money/currency.dart';

enum CreditRequestStatus { pending, disbursed, repaid }

class CreditRequest {
  const CreditRequest({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.createdAt,
    this.status = CreditRequestStatus.pending,
    this.repaidAmount = 0,
  });

  final String id;
  final String userId;
  final double amount;
  final Currency currency;
  final DateTime createdAt;
  final CreditRequestStatus status;
  final double repaidAmount;

  double get outstandingAmount =>
      ((amount - repaidAmount) * 100).roundToDouble() / 100;

  CreditRequest copyWith({CreditRequestStatus? status, double? repaidAmount}) =>
      CreditRequest(
        id: id,
        userId: userId,
        amount: amount,
        currency: currency,
        createdAt: createdAt,
        status: status ?? this.status,
        repaidAmount: repaidAmount ?? this.repaidAmount,
      );
}
