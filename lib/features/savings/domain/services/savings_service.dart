import '../../../../core/money/currency.dart';
import '../../../wallet/domain/services/wallet_service.dart';
import '../models/savings_investment.dart';

class SavingsService {
  SavingsService({
    required this.wallet,
    required this.annualInterestRate,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now {
    if (!annualInterestRate.isFinite || annualInterestRate < 0) {
      throw ArgumentError.value(
        annualInterestRate,
        'annualInterestRate',
        'Le taux annuel doit être positif ou nul.',
      );
    }
  }

  final WalletService wallet;
  final DateTime Function() _clock;
  final double annualInterestRate;
  final List<SavingsInvestment> _investments = [];
  int _nextId = 0;

  List<SavingsInvestment> investmentsFor(String userId) => List.unmodifiable(
    _investments.where((investment) => investment.userId == userId),
  );

  SavingsInvestment invest({
    required String userId,
    required Currency currency,
    required double amount,
  }) {
    if (!amount.isFinite || amount <= 0) {
      throw ArgumentError.value(amount, 'amount', 'Montant invalide.');
    }

    wallet.investInSavings(userId: userId, currency: currency, amount: amount);
    final investment = SavingsInvestment(
      id: 'sav-${++_nextId}',
      userId: userId,
      principal: (amount * 100).roundToDouble() / 100,
      currency: currency,
      annualInterestRate: annualInterestRate,
      startedAt: _clock(),
    );
    _investments.insert(0, investment);
    return investment;
  }
}
