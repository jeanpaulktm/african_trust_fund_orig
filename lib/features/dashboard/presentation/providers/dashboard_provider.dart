import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:african/core/api/api_service.dart';
import 'package:african/features/dashboard/data/models/dashboard_models.dart';
import 'package:african/features/dashboard/data/repositories/dashboard_repository.dart';

// ==================== Repository Provider ====================

/// Provider pour DashboardRepository
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  final apiService = ref.watch(
    Provider<ApiService>(
      (ref) => throw UnimplementedError(),
    ),
  );
  return DashboardRepository(apiService: apiService);
});

// ==================== État Dashboard ====================

class DashboardState {
  final DashboardData? data;
  final bool isLoading;
  final String? error;
  final DateTime? lastFetchedAt;

  DashboardState({
    this.data,
    this.isLoading = false,
    this.error,
    this.lastFetchedAt,
  });

  DashboardState copyWith({
    DashboardData? data,
    bool? isLoading,
    String? error,
    DateTime? lastFetchedAt,
  }) {
    return DashboardState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastFetchedAt: lastFetchedAt ?? this.lastFetchedAt,
    );
  }
}

// ==================== Notifier ====================

class DashboardNotifier extends StateNotifier<DashboardState> {
  final DashboardRepository repository;

  DashboardNotifier({required this.repository}) : super(DashboardState());

  /// Charger les données du dashboard
  Future<void> fetchDashboard() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await repository.getDashboard();

      if (response.success) {
        state = state.copyWith(
          data: response.data,
          isLoading: false,
          error: null,
          lastFetchedAt: DateTime.now(),
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Erreur lors du chargement du dashboard',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Rafraîchir les données du dashboard
  Future<void> refreshDashboard() async {
    await fetchDashboard();
  }
}

/// Provider pour le Dashboard
final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return DashboardNotifier(repository: repository);
});
