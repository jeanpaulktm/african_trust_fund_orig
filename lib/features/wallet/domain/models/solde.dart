import '../../../../core/money/currency.dart';

class Solde {
  const Solde({required this.amount, required this.currency});

  final double amount;
  final Currency currency;

  Solde credit(double value) {
    _requirePositiveFinite(value);
    return Solde(amount: amount + value, currency: currency);
  }

  Solde debit(double value) {
    _requirePositiveFinite(value);
    if (value > amount) {
      throw StateError('Solde insuffisant en ${currency.code}.');
    }
    return Solde(amount: amount - value, currency: currency);
  }

  static void _requirePositiveFinite(double value) {
    if (!value.isFinite || value <= 0) {
      throw ArgumentError.value(
        value,
        'value',
        'Doit être un montant positif.',
      );
    }
  }
}
