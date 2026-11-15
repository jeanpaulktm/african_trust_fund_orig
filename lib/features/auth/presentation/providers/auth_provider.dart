import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

import 'package:african/core/api/api_service.dart';
import 'package:african/core/api/api_config.dart';
import 'package:african/features/auth/data/models/auth_models.dart';
import 'package:african/features/auth/data/repositories/auth_repository.dart';

// ==================== Providers Singleton ====================

/// Provider pour FlutterSecureStorage
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

/// Provider pour Logger
final loggerProvider = Provider<Logger>((ref) {
  return Logger();
});

/// Provider pour ApiService
final apiServiceProvider = Provider<ApiService>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final logger = ref.watch(loggerProvider);

  final apiService = ApiService(
    secureStorage: secureStorage,
    logger: logger,
  );
  apiService.initialize();
  return apiService;
});

/// Provider pour AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthRepository(apiService: apiService);
});

// ==================== État d'Authentification ====================

/// État de l'authentification
class AuthState {
  final String? token;
  final String? refreshToken;
  final UserData? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.token,
    this.refreshToken,
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    String? token,
    String? refreshToken,
    UserData? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

/// Notifier pour gérer l'état d'authentification
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final FlutterSecureStorage secureStorage;
  final Logger logger;

  AuthNotifier({
    required this.authRepository,
    required this.secureStorage,
    required this.logger,
  }) : super(AuthState());

  /// Connexion utilisateur
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await authRepository.login(
        email: email,
        password: password,
      );

      if (response.success) {
        final token = response.data.token;
        final refreshToken = response.data.refreshToken;
        final user = response.data.user;

        // Sauvegarder le token de manière sécurisée
        await secureStorage.write(key: ApiConfig.authTokenKey, value: token);
        if (refreshToken != null) {
          await secureStorage.write(
            key: ApiConfig.refreshTokenKey,
            value: refreshToken,
          );
        }

        state = state.copyWith(
          token: token,
          refreshToken: refreshToken,
          user: user,
          isAuthenticated: true,
          isLoading: false,
        );

        logger.i('Connexion réussie: ${user.email}');
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Connexion échouée',
        );
      }
    } catch (e) {
      logger.e('Erreur de connexion: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Enregistrement nouvel utilisateur
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await authRepository.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );

      if (response.success) {
        state = state.copyWith(
          isLoading: false,
          error: null,
        );
        logger.i('Enregistrement réussi: ${response.data.email}');
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Enregistrement échoué',
        );
      }
    } catch (e) {
      logger.e('Erreur d\'enregistrement: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Renouvellement du token
  Future<void> refreshAuthToken() async {
    try {
      final refreshToken = state.refreshToken;
      if (refreshToken == null) {
        logger.w('Pas de refresh token disponible');
        return;
      }

      final response = await authRepository.refreshToken(
        refreshToken: refreshToken,
      );

      if (response.success) {
        final newToken = response.data.token;
        await secureStorage.write(
          key: ApiConfig.authTokenKey,
          value: newToken,
        );

        state = state.copyWith(token: newToken);
        logger.i('Token renouvelé');
      }
    } catch (e) {
      logger.e('Erreur lors du renouvellement du token: $e');
    }
  }

  /// Déconnexion
  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await authRepository.logout();

      // Supprimer les tokens stockés
      await secureStorage.delete(key: ApiConfig.authTokenKey);
      await secureStorage.delete(key: ApiConfig.refreshTokenKey);

      state = AuthState();
      logger.i('Déconnexion réussie');
    } catch (e) {
      logger.e('Erreur lors de la déconnexion: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Récupérer le profil utilisateur
  Future<void> fetchProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await authRepository.getProfile();

      if (response.success) {
        // Convertir ProfileData en UserData (adaptation si nécessaire)
        state = state.copyWith(
          isLoading: false,
          error: null,
        );
        logger.i('Profil chargé');
      }
    } catch (e) {
      logger.e('Erreur lors du chargement du profil: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Récupérer le token stocké au démarrage
  Future<void> checkStoredToken() async {
    try {
      final token = await secureStorage.read(key: ApiConfig.authTokenKey);
      final refreshToken = await secureStorage.read(
        key: ApiConfig.refreshTokenKey,
      );

      if (token != null) {
        state = state.copyWith(
          token: token,
          refreshToken: refreshToken,
          isAuthenticated: true,
        );
        logger.i('Token trouvé en stockage');
      }
    } catch (e) {
      logger.e('Erreur lors de la vérification du token: $e');
    }
  }
}

/// Provider d'état d'authentification
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final logger = ref.watch(loggerProvider);

  return AuthNotifier(
    authRepository: authRepository,
    secureStorage: secureStorage,
    logger: logger,
  );
});

/// Selector pour savoir si l'utilisateur est authentifié
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

/// Selector pour obtenir l'utilisateur courant
final currentUserProvider = Provider<UserData?>((ref) {
  return ref.watch(authProvider).user;
});

/// Selector pour obtenir le token courant
final authTokenProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).token;
});
