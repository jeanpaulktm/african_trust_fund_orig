import 'package:african/core/api/api_service.dart';
import 'package:african/features/dashboard/data/models/dashboard_models.dart';

/// Repository pour le Dashboard
class DashboardRepository {
  final ApiService apiService;

  DashboardRepository({required this.apiService});

  /// Récupérer les données complètes du dashboard
  Future<DashboardResponse> getDashboard() async {
    final response = await apiService.get('/api/v1/dashboard');
    return DashboardResponse.fromJson(response);
  }
}
