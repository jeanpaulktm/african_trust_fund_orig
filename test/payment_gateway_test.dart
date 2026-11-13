import 'package:african/core/money/currency.dart';
import 'package:african/features/payments/domain/models/payment_result.dart';
import 'package:african/features/payments/domain/services/payment_gateway.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseCounterWithdrawalQr', () {
    test('accepts an opaque ticket identifier', () {
      expect(
        parseCounterWithdrawalQr('ATF:WITHDRAWAL:ticket_0123456789-AB'),
        'ticket_0123456789-AB',
      );
    });

    test('rejects personal data, malformed and short payloads', () {
      expect(
        parseCounterWithdrawalQr('ATF:WITHDRAWAL:john@example.com'),
        isNull,
      );
      expect(parseCounterWithdrawalQr('ATF:WITHDRAWAL:short'), isNull);
      expect(parseCounterWithdrawalQr(null), isNull);
    });
  });

  test('unconfigured payment gateway explicitly reports no movement', () async {
    const gateway = UnavailablePaymentGateway();

    final result = await gateway.depositByMobileMoney(
      userId: 'client-1',
      phoneNumber: '+243812345678',
      provider: MobileMoneyProvider.mpesa,
      currency: Currency.usd,
      amount: 25,
    );

    expect(result.status, PaymentStatus.unavailable);
    expect(result.message, contains('Aucun paiement ni dépôt'));
    await expectLater(
      gateway.createCounterWithdrawal(
        userId: 'client-1',
        currency: Currency.usd,
        amount: 25,
        fee: .25,
      ),
      throwsStateError,
    );
  });
}
