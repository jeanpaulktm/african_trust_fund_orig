import 'package:african/core/api/api_service.dart';
import 'package:african/features/credit/data/models/loan_models.dart';

/// Repository pour les prêts
class LoanRepository {
  final ApiService apiService;

  LoanRepository({required this.apiService});

  /// Récupérer la liste des prêts
  Future<LoansListResponse> getLoans({
    int page = 1,
    int perPage = 10,
    String? status,
    String? sort,
  }) async {
    final response = await apiService.get(
      '/api/v1/prets',
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (status != null) 'status': status,
        if (sort != null) 'sort': sort,
      },
    );

    return LoansListResponse.fromJson(response);
  }

  /// Récupérer les détails d'un prêt
  Future<LoanDetailResponse> getLoanDetails(String loanId) async {
    final response = await apiService.get('/api/v1/prets/$loanId');
    return LoanDetailResponse.fromJson(response);
  }

  /// Demander un nouveau prêt
  Future<LoanRequestResponse> requestLoan({
    required double amount,
    required String currency,
    required String loanType,
    required int termMonths,
    required String purpose,
  }) async {
    final response = await apiService.post(
      '/api/v1/prets/demand',
      data: {
        'amount': amount,
        'currency': currency,
        'loan_type': loanType,
        'term_months': termMonths,
        'purpose': purpose,
      },
    );

    return LoanRequestResponse.fromJson(response);
  }

  /// Simuler un prêt
  Future<LoanSimulationResponse> simulateLoan({
    required double amount,
    required String currency,
    required String loanType,
    required int termMonths,
  }) async {
    final response = await apiService.post(
      '/api/v1/prets/simuler',
      data: {
        'amount': amount,
        'currency': currency,
        'loan_type': loanType,
        'term_months': termMonths,
      },
    );

    return LoanSimulationResponse.fromJson(response);
  }

  /// Effectuer un remboursement
  Future<Map<String, dynamic>> repayLoan({
    required String loanId,
    required double amount,
    String paymentMethod = 'mobile_money',
  }) async {
    final response = await apiService.post(
      '/api/v1/prets/$loanId/repay',
      data: {
        'amount': amount,
        'payment_method': paymentMethod,
      },
    );

    return response;
  }
}
