// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoansListResponse _$LoansListResponseFromJson(Map<String, dynamic> json) =>
    LoansListResponse(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((e) => LoanSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] == null
          ? null
          : Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$LoansListResponseToJson(LoansListResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'pagination': instance.pagination,
      'timestamp': instance.timestamp,
    };

LoanSummary _$LoanSummaryFromJson(Map<String, dynamic> json) => LoanSummary(
  id: json['id'] as String,
  reference: json['reference'] as String,
  amountRequested: (json['amount_requested'] as num).toDouble(),
  amountApproved: (json['amount_approved'] as num).toDouble(),
  currency: json['currency'] as String,
  status: json['status'] as String,
  interestRate: (json['interest_rate'] as num).toDouble(),
  termMonths: (json['term_months'] as num).toInt(),
  balanceOutstanding: (json['balance_outstanding'] as num).toDouble(),
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$LoanSummaryToJson(LoanSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reference': instance.reference,
      'amount_requested': instance.amountRequested,
      'amount_approved': instance.amountApproved,
      'currency': instance.currency,
      'status': instance.status,
      'interest_rate': instance.interestRate,
      'term_months': instance.termMonths,
      'balance_outstanding': instance.balanceOutstanding,
      'created_at': instance.createdAt,
    };

LoanDetailResponse _$LoanDetailResponseFromJson(Map<String, dynamic> json) =>
    LoanDetailResponse(
      success: json['success'] as bool,
      data: LoanDetail.fromJson(json['data'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$LoanDetailResponseToJson(LoanDetailResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'timestamp': instance.timestamp,
    };

LoanDetail _$LoanDetailFromJson(Map<String, dynamic> json) => LoanDetail(
  id: json['id'] as String,
  reference: json['reference'] as String,
  amountRequested: (json['amount_requested'] as num).toDouble(),
  amountApproved: (json['amount_approved'] as num).toDouble(),
  currency: json['currency'] as String,
  status: json['status'] as String,
  interestRate: (json['interest_rate'] as num).toDouble(),
  loanType: json['loan_type'] as String,
  termMonths: (json['term_months'] as num).toInt(),
  monthlyPayment: (json['monthly_payment'] as num).toDouble(),
  totalToRepay: (json['total_to_repay'] as num).toDouble(),
  balanceOutstanding: (json['balance_outstanding'] as num).toDouble(),
  repaidToDate: (json['repaid_to_date'] as num).toDouble(),
  startDate: json['start_date'] as String,
  maturityDate: json['maturity_date'] as String,
  disbursementDate: json['disbursement_date'] as String?,
  schedule: (json['schedule'] as List<dynamic>)
      .map((e) => ScheduleItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  repaymentHistory: (json['repayment_history'] as List<dynamic>)
      .map((e) => RepaymentHistory.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LoanDetailToJson(LoanDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reference': instance.reference,
      'amount_requested': instance.amountRequested,
      'amount_approved': instance.amountApproved,
      'currency': instance.currency,
      'status': instance.status,
      'interest_rate': instance.interestRate,
      'loan_type': instance.loanType,
      'term_months': instance.termMonths,
      'monthly_payment': instance.monthlyPayment,
      'total_to_repay': instance.totalToRepay,
      'balance_outstanding': instance.balanceOutstanding,
      'repaid_to_date': instance.repaidToDate,
      'start_date': instance.startDate,
      'maturity_date': instance.maturityDate,
      'disbursement_date': instance.disbursementDate,
      'schedule': instance.schedule,
      'repayment_history': instance.repaymentHistory,
    };

ScheduleItem _$ScheduleItemFromJson(Map<String, dynamic> json) => ScheduleItem(
  dueDate: json['due_date'] as String,
  period: (json['period'] as num).toInt(),
  openingBalance: (json['opening_balance'] as num).toDouble(),
  paymentAmount: (json['payment_amount'] as num).toDouble(),
  principal: (json['principal'] as num).toDouble(),
  interest: (json['interest'] as num).toDouble(),
  closingBalance: (json['closing_balance'] as num).toDouble(),
  status: json['status'] as String,
);

Map<String, dynamic> _$ScheduleItemToJson(ScheduleItem instance) =>
    <String, dynamic>{
      'due_date': instance.dueDate,
      'period': instance.period,
      'opening_balance': instance.openingBalance,
      'payment_amount': instance.paymentAmount,
      'principal': instance.principal,
      'interest': instance.interest,
      'closing_balance': instance.closingBalance,
      'status': instance.status,
    };

RepaymentHistory _$RepaymentHistoryFromJson(Map<String, dynamic> json) =>
    RepaymentHistory(
      id: json['id'] as String,
      date: json['date'] as String,
      amountPaid: (json['amount_paid'] as num).toDouble(),
      principalPaid: (json['principal_paid'] as num).toDouble(),
      interestPaid: (json['interest_paid'] as num).toDouble(),
      balanceAfter: (json['balance_after'] as num).toDouble(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$RepaymentHistoryToJson(RepaymentHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'amount_paid': instance.amountPaid,
      'principal_paid': instance.principalPaid,
      'interest_paid': instance.interestPaid,
      'balance_after': instance.balanceAfter,
      'status': instance.status,
    };

LoanRequestPayload _$LoanRequestPayloadFromJson(Map<String, dynamic> json) =>
    LoanRequestPayload(
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      loanType: json['loan_type'] as String,
      termMonths: (json['term_months'] as num).toInt(),
      purpose: json['purpose'] as String,
    );

Map<String, dynamic> _$LoanRequestPayloadToJson(LoanRequestPayload instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'currency': instance.currency,
      'loan_type': instance.loanType,
      'term_months': instance.termMonths,
      'purpose': instance.purpose,
    };

LoanRequestResponse _$LoanRequestResponseFromJson(Map<String, dynamic> json) =>
    LoanRequestResponse(
      success: json['success'] as bool,
      data: LoanRequestData.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
    );

Map<String, dynamic> _$LoanRequestResponseToJson(
  LoanRequestResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'message': instance.message,
};

LoanRequestData _$LoanRequestDataFromJson(Map<String, dynamic> json) =>
    LoanRequestData(
      loanId: json['loan_id'] as String,
      reference: json['reference'] as String,
      status: json['status'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$LoanRequestDataToJson(LoanRequestData instance) =>
    <String, dynamic>{
      'loan_id': instance.loanId,
      'reference': instance.reference,
      'status': instance.status,
      'message': instance.message,
    };

LoanSimulationRequest _$LoanSimulationRequestFromJson(
  Map<String, dynamic> json,
) => LoanSimulationRequest(
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
  loanType: json['loan_type'] as String,
  termMonths: (json['term_months'] as num).toInt(),
);

Map<String, dynamic> _$LoanSimulationRequestToJson(
  LoanSimulationRequest instance,
) => <String, dynamic>{
  'amount': instance.amount,
  'currency': instance.currency,
  'loan_type': instance.loanType,
  'term_months': instance.termMonths,
};

LoanSimulationResponse _$LoanSimulationResponseFromJson(
  Map<String, dynamic> json,
) => LoanSimulationResponse(
  success: json['success'] as bool,
  data: SimulationData.fromJson(json['data'] as Map<String, dynamic>),
  timestamp: json['timestamp'] as String,
);

Map<String, dynamic> _$LoanSimulationResponseToJson(
  LoanSimulationResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'timestamp': instance.timestamp,
};

SimulationData _$SimulationDataFromJson(Map<String, dynamic> json) =>
    SimulationData(
      amountRequested: (json['amount_requested'] as num).toDouble(),
      interestRate: (json['interest_rate'] as num).toDouble(),
      termMonths: (json['term_months'] as num).toInt(),
      monthlyPayment: (json['monthly_payment'] as num).toDouble(),
      totalInterest: (json['total_interest'] as num).toDouble(),
      totalToRepay: (json['total_to_repay'] as num).toDouble(),
    );

Map<String, dynamic> _$SimulationDataToJson(SimulationData instance) =>
    <String, dynamic>{
      'amount_requested': instance.amountRequested,
      'interest_rate': instance.interestRate,
      'term_months': instance.termMonths,
      'monthly_payment': instance.monthlyPayment,
      'total_interest': instance.totalInterest,
      'total_to_repay': instance.totalToRepay,
    };

RepaymentRequest _$RepaymentRequestFromJson(Map<String, dynamic> json) =>
    RepaymentRequest(
      loanId: json['loan_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['payment_method'] as String,
    );

Map<String, dynamic> _$RepaymentRequestToJson(RepaymentRequest instance) =>
    <String, dynamic>{
      'loan_id': instance.loanId,
      'amount': instance.amount,
      'payment_method': instance.paymentMethod,
    };

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
  currentPage: (json['current_page'] as num).toInt(),
  perPage: (json['per_page'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  totalPages: (json['total_pages'] as num).toInt(),
  hasNext: json['has_next'] as bool,
  hasPrev: json['has_prev'] as bool,
);

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'per_page': instance.perPage,
      'total': instance.total,
      'total_pages': instance.totalPages,
      'has_next': instance.hasNext,
      'has_prev': instance.hasPrev,
    };
