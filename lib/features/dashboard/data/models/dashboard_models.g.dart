// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardResponse _$DashboardResponseFromJson(Map<String, dynamic> json) =>
    DashboardResponse(
      success: json['success'] as bool,
      data: DashboardData.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$DashboardResponseToJson(DashboardResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'timestamp': instance.timestamp,
    };

DashboardData _$DashboardDataFromJson(Map<String, dynamic> json) =>
    DashboardData(
      userId: json['user_id'] as String,
      balances: Balances.fromJson(json['balances'] as Map<String, dynamic>),
      loanStats: LoanStats.fromJson(json['loan_stats'] as Map<String, dynamic>),
      placementStats: PlacementStats.fromJson(
        json['placement_stats'] as Map<String, dynamic>,
      ),
      recentTransactions: (json['recent_transactions'] as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextPayment: json['next_payment'] == null
          ? null
          : NextPayment.fromJson(json['next_payment'] as Map<String, dynamic>),
      totalInterestEarned: (json['total_interest_earned'] as num).toDouble(),
    );

Map<String, dynamic> _$DashboardDataToJson(DashboardData instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'balances': instance.balances,
      'loan_stats': instance.loanStats,
      'placement_stats': instance.placementStats,
      'recent_transactions': instance.recentTransactions,
      'next_payment': instance.nextPayment,
      'total_interest_earned': instance.totalInterestEarned,
    };

Balances _$BalancesFromJson(Map<String, dynamic> json) => Balances(
  cdf: (json['cdf'] as num).toDouble(),
  usd: (json['usd'] as num).toDouble(),
  totalEquivalentCdf: (json['total_equivalent_cdf'] as num).toDouble(),
  savingsBalance: (json['savings_balance'] as num).toDouble(),
);

Map<String, dynamic> _$BalancesToJson(Balances instance) => <String, dynamic>{
  'cdf': instance.cdf,
  'usd': instance.usd,
  'total_equivalent_cdf': instance.totalEquivalentCdf,
  'savings_balance': instance.savingsBalance,
};

LoanStats _$LoanStatsFromJson(Map<String, dynamic> json) => LoanStats(
  totalBorrowed: (json['total_borrowed'] as num).toDouble(),
  totalRepaid: (json['total_repaid'] as num).toDouble(),
  activeLoans: (json['active_loans'] as num).toInt(),
  completedLoans: (json['completed_loans'] as num).toInt(),
  overdueLoans: (json['overdue_loans'] as num).toInt(),
  totalOutstanding: (json['total_outstanding'] as num).toDouble(),
);

Map<String, dynamic> _$LoanStatsToJson(LoanStats instance) => <String, dynamic>{
  'total_borrowed': instance.totalBorrowed,
  'total_repaid': instance.totalRepaid,
  'active_loans': instance.activeLoans,
  'completed_loans': instance.completedLoans,
  'overdue_loans': instance.overdueLoans,
  'total_outstanding': instance.totalOutstanding,
};

PlacementStats _$PlacementStatsFromJson(Map<String, dynamic> json) =>
    PlacementStats(
      totalInvested: (json['total_invested'] as num).toDouble(),
      activePlacements: (json['active_placements'] as num).toInt(),
      closedPlacements: (json['closed_placements'] as num).toInt(),
      accumulatedInterest: (json['accumulated_interest'] as num).toDouble(),
    );

Map<String, dynamic> _$PlacementStatsToJson(PlacementStats instance) =>
    <String, dynamic>{
      'total_invested': instance.totalInvested,
      'active_placements': instance.activePlacements,
      'closed_placements': instance.closedPlacements,
      'accumulated_interest': instance.accumulatedInterest,
    };

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
  id: json['id'] as String,
  type: json['type'] as String,
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
  status: json['status'] as String,
  description: json['description'] as String,
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': instance.status,
      'description': instance.description,
      'created_at': instance.createdAt,
    };

NextPayment _$NextPaymentFromJson(Map<String, dynamic> json) => NextPayment(
  loanId: json['loan_id'] as String,
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
  dueDate: json['due_date'] as String,
  daysUntilDue: (json['days_until_due'] as num).toInt(),
  status: json['status'] as String,
);

Map<String, dynamic> _$NextPaymentToJson(NextPayment instance) =>
    <String, dynamic>{
      'loan_id': instance.loanId,
      'amount': instance.amount,
      'currency': instance.currency,
      'due_date': instance.dueDate,
      'days_until_due': instance.daysUntilDue,
      'status': instance.status,
    };
