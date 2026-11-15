import 'package:json_annotation/json_annotation.dart';

part 'loan_models.g.dart';

/// Réponse liste prêts
@JsonSerializable()
class LoansListResponse {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'data')
  final List<LoanSummary> data;

  @JsonKey(name: 'pagination')
  final Pagination? pagination;

  @JsonKey(name: 'timestamp')
  final String timestamp;

  LoansListResponse({
    required this.success,
    required this.data,
    this.pagination,
    required this.timestamp,
  });

  factory LoansListResponse.fromJson(Map<String, dynamic> json) =>
      _$LoansListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoansListResponseToJson(this);
}

/// Résumé d'un prêt
@JsonSerializable()
class LoanSummary {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'reference')
  final String reference;

  @JsonKey(name: 'amount_requested')
  final double amountRequested;

  @JsonKey(name: 'amount_approved')
  final double amountApproved;

  @JsonKey(name: 'currency')
  final String currency;

  @JsonKey(name: 'status')
  final String status;

  @JsonKey(name: 'interest_rate')
  final double interestRate;

  @JsonKey(name: 'term_months')
  final int termMonths;

  @JsonKey(name: 'balance_outstanding')
  final double balanceOutstanding;

  @JsonKey(name: 'created_at')
  final String createdAt;

  LoanSummary({
    required this.id,
    required this.reference,
    required this.amountRequested,
    required this.amountApproved,
    required this.currency,
    required this.status,
    required this.interestRate,
    required this.termMonths,
    required this.balanceOutstanding,
    required this.createdAt,
  });

  factory LoanSummary.fromJson(Map<String, dynamic> json) =>
      _$LoanSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$LoanSummaryToJson(this);
}

/// Détails complets d'un prêt
@JsonSerializable()
class LoanDetailResponse {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'data')
  final LoanDetail data;

  @JsonKey(name: 'timestamp')
  final String timestamp;

  LoanDetailResponse({
    required this.success,
    required this.data,
    required this.timestamp,
  });

  factory LoanDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$LoanDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoanDetailResponseToJson(this);
}

/// Détails complets d'un prêt
@JsonSerializable()
class LoanDetail {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'reference')
  final String reference;

  @JsonKey(name: 'amount_requested')
  final double amountRequested;

  @JsonKey(name: 'amount_approved')
  final double amountApproved;

  @JsonKey(name: 'currency')
  final String currency;

  @JsonKey(name: 'status')
  final String status;

  @JsonKey(name: 'interest_rate')
  final double interestRate;

  @JsonKey(name: 'loan_type')
  final String loanType;

  @JsonKey(name: 'term_months')
  final int termMonths;

  @JsonKey(name: 'monthly_payment')
  final double monthlyPayment;

  @JsonKey(name: 'total_to_repay')
  final double totalToRepay;

  @JsonKey(name: 'balance_outstanding')
  final double balanceOutstanding;

  @JsonKey(name: 'repaid_to_date')
  final double repaidToDate;

  @JsonKey(name: 'start_date')
  final String startDate;

  @JsonKey(name: 'maturity_date')
  final String maturityDate;

  @JsonKey(name: 'disbursement_date')
  final String? disbursementDate;

  @JsonKey(name: 'schedule')
  final List<ScheduleItem> schedule;

  @JsonKey(name: 'repayment_history')
  final List<RepaymentHistory> repaymentHistory;

  LoanDetail({
    required this.id,
    required this.reference,
    required this.amountRequested,
    required this.amountApproved,
    required this.currency,
    required this.status,
    required this.interestRate,
    required this.loanType,
    required this.termMonths,
    required this.monthlyPayment,
    required this.totalToRepay,
    required this.balanceOutstanding,
    required this.repaidToDate,
    required this.startDate,
    required this.maturityDate,
    this.disbursementDate,
    required this.schedule,
    required this.repaymentHistory,
  });

  factory LoanDetail.fromJson(Map<String, dynamic> json) =>
      _$LoanDetailFromJson(json);

  Map<String, dynamic> toJson() => _$LoanDetailToJson(this);
}

/// Élément d'échéancier
@JsonSerializable()
class ScheduleItem {
  @JsonKey(name: 'due_date')
  final String dueDate;

  @JsonKey(name: 'period')
  final int period;

  @JsonKey(name: 'opening_balance')
  final double openingBalance;

  @JsonKey(name: 'payment_amount')
  final double paymentAmount;

  @JsonKey(name: 'principal')
  final double principal;

  @JsonKey(name: 'interest')
  final double interest;

  @JsonKey(name: 'closing_balance')
  final double closingBalance;

  @JsonKey(name: 'status')
  final String status;

  ScheduleItem({
    required this.dueDate,
    required this.period,
    required this.openingBalance,
    required this.paymentAmount,
    required this.principal,
    required this.interest,
    required this.closingBalance,
    required this.status,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) =>
      _$ScheduleItemFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleItemToJson(this);
}

/// Historique de remboursement
@JsonSerializable()
class RepaymentHistory {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'date')
  final String date;

  @JsonKey(name: 'amount_paid')
  final double amountPaid;

  @JsonKey(name: 'principal_paid')
  final double principalPaid;

  @JsonKey(name: 'interest_paid')
  final double interestPaid;

  @JsonKey(name: 'balance_after')
  final double balanceAfter;

  @JsonKey(name: 'status')
  final String status;

  RepaymentHistory({
    required this.id,
    required this.date,
    required this.amountPaid,
    required this.principalPaid,
    required this.interestPaid,
    required this.balanceAfter,
    required this.status,
  });

  factory RepaymentHistory.fromJson(Map<String, dynamic> json) =>
      _$RepaymentHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$RepaymentHistoryToJson(this);
}

/// Demande de prêt
@JsonSerializable()
class LoanRequestPayload {
  @JsonKey(name: 'amount')
  final double amount;

  @JsonKey(name: 'currency')
  final String currency;

  @JsonKey(name: 'loan_type')
  final String loanType;

  @JsonKey(name: 'term_months')
  final int termMonths;

  @JsonKey(name: 'purpose')
  final String purpose;

  LoanRequestPayload({
    required this.amount,
    required this.currency,
    required this.loanType,
    required this.termMonths,
    required this.purpose,
  });

  factory LoanRequestPayload.fromJson(Map<String, dynamic> json) =>
      _$LoanRequestPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$LoanRequestPayloadToJson(this);
}

/// Réponse de demande de prêt
@JsonSerializable()
class LoanRequestResponse {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'data')
  final LoanRequestData data;

  @JsonKey(name: 'message')
  final String message;

  LoanRequestResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory LoanRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$LoanRequestResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoanRequestResponseToJson(this);
}

/// Données de réponse de demande
@JsonSerializable()
class LoanRequestData {
  @JsonKey(name: 'loan_id')
  final String loanId;

  @JsonKey(name: 'reference')
  final String reference;

  @JsonKey(name: 'status')
  final String status;

  @JsonKey(name: 'message')
  final String message;

  LoanRequestData({
    required this.loanId,
    required this.reference,
    required this.status,
    required this.message,
  });

  factory LoanRequestData.fromJson(Map<String, dynamic> json) =>
      _$LoanRequestDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoanRequestDataToJson(this);
}

/// Simulateur de prêt
@JsonSerializable()
class LoanSimulationRequest {
  @JsonKey(name: 'amount')
  final double amount;

  @JsonKey(name: 'currency')
  final String currency;

  @JsonKey(name: 'loan_type')
  final String loanType;

  @JsonKey(name: 'term_months')
  final int termMonths;

  LoanSimulationRequest({
    required this.amount,
    required this.currency,
    required this.loanType,
    required this.termMonths,
  });

  factory LoanSimulationRequest.fromJson(Map<String, dynamic> json) =>
      _$LoanSimulationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoanSimulationRequestToJson(this);
}

/// Réponse de simulation
@JsonSerializable()
class LoanSimulationResponse {
  @JsonKey(name: 'success')
  final bool success;

  @JsonKey(name: 'data')
  final SimulationData data;

  @JsonKey(name: 'timestamp')
  final String timestamp;

  LoanSimulationResponse({
    required this.success,
    required this.data,
    required this.timestamp,
  });

  factory LoanSimulationResponse.fromJson(Map<String, dynamic> json) =>
      _$LoanSimulationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoanSimulationResponseToJson(this);
}

/// Données de simulation
@JsonSerializable()
class SimulationData {
  @JsonKey(name: 'amount_requested')
  final double amountRequested;

  @JsonKey(name: 'interest_rate')
  final double interestRate;

  @JsonKey(name: 'term_months')
  final int termMonths;

  @JsonKey(name: 'monthly_payment')
  final double monthlyPayment;

  @JsonKey(name: 'total_interest')
  final double totalInterest;

  @JsonKey(name: 'total_to_repay')
  final double totalToRepay;

  SimulationData({
    required this.amountRequested,
    required this.interestRate,
    required this.termMonths,
    required this.monthlyPayment,
    required this.totalInterest,
    required this.totalToRepay,
  });

  factory SimulationData.fromJson(Map<String, dynamic> json) =>
      _$SimulationDataFromJson(json);

  Map<String, dynamic> toJson() => _$SimulationDataToJson(this);
}

/// Remboursement de prêt
@JsonSerializable()
class RepaymentRequest {
  @JsonKey(name: 'loan_id')
  final String loanId;

  @JsonKey(name: 'amount')
  final double amount;

  @JsonKey(name: 'payment_method')
  final String paymentMethod;

  RepaymentRequest({
    required this.loanId,
    required this.amount,
    required this.paymentMethod,
  });

  factory RepaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$RepaymentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RepaymentRequestToJson(this);
}

/// Pagination
@JsonSerializable()
class Pagination {
  @JsonKey(name: 'current_page')
  final int currentPage;

  @JsonKey(name: 'per_page')
  final int perPage;

  @JsonKey(name: 'total')
  final int total;

  @JsonKey(name: 'total_pages')
  final int totalPages;

  @JsonKey(name: 'has_next')
  final bool hasNext;

  @JsonKey(name: 'has_prev')
  final bool hasPrev;

  Pagination({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}
