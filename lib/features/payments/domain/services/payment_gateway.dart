import '../../../../core/money/currency.dart';
import '../models/payment_result.dart';
import '../models/withdrawal_ticket.dart';

enum MobileMoneyProvider { mpesa, orangeMoney, airtelMoney }

extension MobileMoneyProviderLabel on MobileMoneyProvider {
  String get label => switch (this) {
    MobileMoneyProvider.mpesa => 'M-Pesa',
    MobileMoneyProvider.orangeMoney => 'Orange Money',
    MobileMoneyProvider.airtelMoney => 'Airtel Money',
  };
}

abstract interface class PaymentGateway {
  Future<PaymentResult> depositByMobileMoney({
    required String userId,
    required String phoneNumber,
    required MobileMoneyProvider provider,
    required Currency currency,
    required double amount,
  });

  Future<PaymentResult> withdrawByMobileMoney({
    required String userId,
    required String phoneNumber,
    required MobileMoneyProvider provider,
    required Currency currency,
    required double amount,
    required double fee,
  });

  Future<WithdrawalTicket> createCounterWithdrawal({
    required String userId,
    required Currency currency,
    required double amount,
    required double fee,
  });

  Future<PaymentResult> confirmCounterWithdrawal({
    required String ticketId,
  });
}

class UnavailablePaymentGateway implements PaymentGateway {
  const UnavailablePaymentGateway();

  @override
  Future<PaymentResult> depositByMobileMoney({
    required String userId,
    required String phoneNumber,
    required MobileMoneyProvider provider,
    required Currency currency,
    required double amount,
  }) async => const PaymentResult(
    status: PaymentStatus.unavailable,
    message:
        'Le service de paiement Mobile Money n’est pas encore configuré. '
        'Aucun paiement ni dépôt n’a été effectué.',
  );

  @override
  Future<PaymentResult> withdrawByMobileMoney({
    required String userId,
    required String phoneNumber,
    required MobileMoneyProvider provider,
    required Currency currency,
    required double amount,
    required double fee,
  }) async => const PaymentResult(
    status: PaymentStatus.unavailable,
    message:
        'Le service de paiement Mobile Money n’est pas encore configuré. '
        'Aucun paiement ni retrait n’a été effectué.',
  );

  @override
  Future<WithdrawalTicket> createCounterWithdrawal({
    required String userId,
    required Currency currency,
    required double amount,
    required double fee,
  }) async {
    throw StateError(
      'Le service de retrait au guichet n’est pas configuré. '
      'Aucun fonds n’a été réservé.',
    );
  }

  @override
  Future<PaymentResult> confirmCounterWithdrawal({
    required String ticketId,
  }) async => const PaymentResult(
    status: PaymentStatus.unavailable,
    message:
        'La confirmation du guichet nécessite un backend sécurisé. '
        'Aucun retrait n’a été confirmé.',
  );
}

String? parseCounterWithdrawalQr(String? rawValue) {
  if (rawValue == null) return null;
  final match = RegExp(r'^ATF:WITHDRAWAL:([A-Za-z0-9_-]{16,128})$').firstMatch(
    rawValue.trim(),
  );
  return match?.group(1);
}
