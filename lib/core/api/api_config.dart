/// Configuration centralisée pour l'API African Trust Fund
class ApiConfig {
  // URLs de base - À adapter selon votre environnement
  static const String baseUrl = 'https://api.africantrust.cd';
  static const String apiVersion = '/api/v1';
  
  // Endpoints complets
  static const String authBaseUrl = '$baseUrl$apiVersion/auth';
  static const String dashboardUrl = '$baseUrl$apiVersion/dashboard';
  static const String pretsUrl = '$baseUrl$apiVersion/prets';
  static const String transactionsUrl = '$baseUrl$apiVersion/transactions';
  static const String placementsUrl = '$baseUrl$apiVersion/placements';
  static const String profilUrl = '$baseUrl$apiVersion/profil';
  
  // Timeouts
  static const int connectTimeout = 30000; // ms
  static const int receiveTimeout = 30000; // ms
  static const int sendTimeout = 30000; // ms
  
  // Headers par défaut
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'AtfMobileApp/1.0',
  };
  
  // Storage keys
  static const String authTokenKey = 'auth_token';
  static const String authTokenExpiryKey = 'auth_token_expiry';
  static const String userDataKey = 'user_data';
  static const String refreshTokenKey = 'refresh_token';
}
