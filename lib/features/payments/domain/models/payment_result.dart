enum PaymentStatus { pending, succeeded, failed, unavailable }

class PaymentResult {
  const PaymentResult({
    required this.status,
    required this.message,
    this.reference,
  });

  final PaymentStatus status;
  final String message;
  final String? reference;
}
