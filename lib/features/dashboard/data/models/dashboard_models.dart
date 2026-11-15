import 'package:json_annotation/json_annotation.dart';

part 'dashboard_models.g.dart';

/// Réponse Dashboard complète
@JsonSerializable()
class DashboardResponse {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'data')
  final DashboardData data;

  @JsonKey(name: 'timestamp')
  final String timestamp;

  DashboardResponse({
    required this.success,
    required this.data,
    required this.timestamp,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) =>
      _$DashboardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardResponseToJson(this);
}

/// Données du dashboard
@JsonSerializable()
class DashboardData {
  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'balances')
  final Balances balances;

  @JsonKey(name: 'loan_stats')
  final LoanStats loanStats;

  @JsonKey(name: 'placement_stats')
  final PlacementStats placementStats;

  @JsonKey(name: 'recent_transactions')
  final List<Transaction> recentTransactions;

  @JsonKey(name: 'next_payment')
  final NextPayment? nextPayment;

  @JsonKey(name: 'total_interest_earned')
  final double totalInterestEarned;

  DashboardData({
    required this.userId,
    required this.balances,
    required this.loanStats,
    required this.placementStats,
    required this.recentTransactions,
    this.nextPayment,
    required this.totalInterestEarned,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardDataToJson(this);
}

/// Soldes en plusieurs devises
@JsonSerializable()
class Balances {
  @JsonKey(name: 'cdf')
  final double cdf;

  @JsonKey(name: 'usd')
  final double usd;

  @JsonKey(name: 'total_equivalent_cdf')
  final double totalEquivalentCdf;

  @JsonKey(name: 'savings_balance')
  final double savingsBalance;

  Balances({
    required this.cdf,
    required this.usd,
    required this.totalEquivalentCdf,
    required this.savingsBalance,
  });

  factory Balances.fromJson(Map<String, dynamic> json) =>
      _$BalancesFromJson(json);

  Map<String, dynamic> toJson() => _$BalancesToJson(this);
}

/// Statistiques des prêts
@JsonSerializable()
class LoanStats {
  @JsonKey(name: 'total_borrowed')
  final double totalBorrowed;

  @JsonKey(name: 'total_repaid')
  final double totalRepaid;

  @JsonKey(name: 'active_loans')
  final int activeLoans;

  @JsonKey(name: 'completed_loans')
  final int completedLoans;

  @JsonKey(name: 'overdue_loans')
  final int overdueLoans;

  @JsonKey(name: 'total_outstanding')
  final double totalOutstanding;

  LoanStats({
    required this.totalBorrowed,
    required this.totalRepaid,
    required this.activeLoans,
    required this.completedLoans,
    required this.overdueLoans,
    required this.totalOutstanding,
  });

  factory LoanStats.fromJson(Map<String, dynamic> json) =>
      _$LoanStatsFromJson(json);

  Map<String, dynamic> toJson() => _$LoanStatsToJson(this);
}

/// Statistiques des placements
@JsonSerializable()
class PlacementStats {
  @JsonKey(name: 'total_invested')
  final double totalInvested;

  @JsonKey(name: 'active_placements')
  final int activePlacements;

  @JsonKey(name: 'closed_placements')
  final int closedPlacements;

  @JsonKey(name: 'accumulated_interest')
  final double accumulatedInterest;

  PlacementStats({
    required this.totalInvested,
    required this.activePlacements,
    required this.closedPlacements,
    required this.accumulatedInterest,
  });

  factory PlacementStats.fromJson(Map<String, dynamic> json) =>
      _$PlacementStatsFromJson(json);

  Map<String, dynamic> toJson() => _$PlacementStatsToJson(this);
}

/// Transaction
@JsonSerializable()
class Transaction {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'type')
  final String type; // 'deposit', 'withdrawal', 'transfer', 'loan_repayment'

  @JsonKey(name: 'amount')
  final double amount;

  @JsonKey(name: 'currency')
  final String currency; // 'CDF', 'USD'

  @JsonKey(name: 'status')
  final String status; // 'complete', 'pending', 'failed'

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'created_at')
  final String createdAt;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.currency,
    required this.status,
    required this.description,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

/// Prochain paiement/échéance
@JsonSerializable()
class NextPayment {
  @JsonKey(name: 'loan_id')
  final String loanId;

  @JsonKey(name: 'amount')
  final double amount;

  @JsonKey(name: 'currency')
  final String currency;

  @JsonKey(name: 'due_date')
  final String dueDate;

  @JsonKey(name: 'days_until_due')
  final int daysUntilDue;

  @JsonKey(name: 'status')
  final String status; // 'on_time', 'due_soon', 'overdue'

  NextPayment({
    required this.loanId,
    required this.amount,
    required this.currency,
    required this.dueDate,
    required this.daysUntilDue,
    required this.status,
  });

  factory NextPayment.fromJson(Map<String, dynamic> json) =>
      _$NextPaymentFromJson(json);

  Map<String, dynamic> toJson() => _$NextPaymentToJson(this);
}
