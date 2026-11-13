import '../../../../core/money/currency.dart';

class SavingsInvestment {
  static const _yearInMicroseconds = 365 * 24 * 60 * 60 * 1000000;

  const SavingsInvestment({
    required this.id,
    required this.userId,
    required this.principal,
    required this.currency,
    required this.annualInterestRate,
    required this.startedAt,
  });

  final String id;
  final String userId;
  final double principal;
  final Currency currency;
  final double annualInterestRate;
  final DateTime startedAt;

  double interestAt(DateTime time) {
    final elapsed = time.difference(startedAt).inMicroseconds;
    if (elapsed <= 0) return 0;
    final interest =
        principal * annualInterestRate * elapsed / _yearInMicroseconds;
    return (interest * 100).roundToDouble() / 100;
  }

  double valueAt(DateTime time) => principal + interestAt(time);
}
