import '../../../../core/money/currency.dart';

class WithdrawalTicket {
  const WithdrawalTicket({
    required this.ticketId,
    required this.reference,
    required this.userId,
    required this.amount,
    required this.fee,
    required this.currency,
    required this.expiresAt,
  });

  final String ticketId;
  final String reference;
  final String userId;
  final double amount;
  final double fee;
  final Currency currency;
  final DateTime expiresAt;

  double get totalDebit => amount + fee;

  String get qrPayload => 'ATF:WITHDRAWAL:$ticketId';
}
