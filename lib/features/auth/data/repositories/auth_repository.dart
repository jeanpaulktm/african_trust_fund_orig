import 'package:african/core/api/api_service.dart';
import 'package:african/features/auth/data/models/auth_models.dart';

/// Repository pour l'authentification
class AuthRepository {
  final ApiService apiService;

  AuthRepository({required this.apiService});

  /// Connexion utilisateur
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await apiService.post(
      '/api/v1/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    return LoginResponse.fromJson(response);
  }

  /// Enregistrement nouvel utilisateur
  Future<RegisterResponse> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    final response = await apiService.post(
      '/api/v1/auth/register',
      data: {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
      },
    );

    return RegisterResponse.fromJson(response);
  }

  /// Renouvellement du token
  Future<RefreshTokenResponse> refreshToken({
    required String refreshToken,
  }) async {
    final response = await apiService.post(
      '/api/v1/auth/refresh',
      data: {
        'refresh_token': refreshToken,
      },
    );

    return RefreshTokenResponse.fromJson(response);
  }

  /// Déconnexion
  Future<Map<String, dynamic>> logout() async {
    final response = await apiService.post(
      '/api/v1/auth/logout',
      data: {},
    );

    return response;
  }

  /// Récupérer le profil utilisateur
  Future<UserProfile> getProfile() async {
    final response = await apiService.get('/api/v1/auth/profile');
    return UserProfile.fromJson(response);
  }
}
