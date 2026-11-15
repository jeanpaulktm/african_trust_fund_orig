import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

import 'api_config.dart';

/// Exception pour les erreurs API
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  ApiException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

/// Intercepteur pour ajouter le token Bearer et gérer les erreurs
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;
  final Logger logger;

  AuthInterceptor({
    required this.secureStorage,
    required this.logger,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await secureStorage.read(key: ApiConfig.authTokenKey);

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
        logger.d('Token ajouté à la requête: ${options.path}');
      }

      return handler.next(options);
    } catch (e) {
      logger.e('Erreur lors de l\'ajout du token: $e');
      return handler.next(options);
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    logger.e('Erreur API: ${err.message}\nStatus: ${err.response?.statusCode}');

    if (err.response?.statusCode == 401) {
      logger.w('Token expiré - Tentative de renouvellement');
      // Logique de refresh token sera implémentée dans AuthService
    }

    return handler.next(err);
  }
}

/// Service API principal
class ApiService {
  late final Dio _dio;
  final FlutterSecureStorage secureStorage;
  final Logger logger;

  ApiService({
    required this.secureStorage,
    Logger? logger,
  }) : logger = logger ?? Logger();

  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: Duration(milliseconds: ApiConfig.connectTimeout),
        receiveTimeout: Duration(milliseconds: ApiConfig.receiveTimeout),
        sendTimeout: Duration(milliseconds: ApiConfig.sendTimeout),
        headers: ApiConfig.defaultHeaders,
      ),
    );

    // Ajouter les intercepteurs
    _dio.interceptors.add(
      AuthInterceptor(
        secureStorage: secureStorage,
        logger: logger,
      ),
    );

    logger.i('ApiService initialisé');
  }

  Dio get dio => _dio;

  /// GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        endpoint,
        queryParameters: queryParameters,
      );

      _validateResponse(response);
      return response.data!;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      _validateResponse(response);
      return response.data!;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      _validateResponse(response);
      return response.data!;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        endpoint,
        queryParameters: queryParameters,
      );

      _validateResponse(response);
      return response.data!;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Upload fichier
  Future<Map<String, dynamic>> uploadFile(
    String endpoint, {
    required String filePath,
    required String fieldName,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        if (additionalData != null) ...additionalData,
      });

      final response = await _dio.post<Map<String, dynamic>>(
        endpoint,
        data: formData,
      );

      _validateResponse(response);
      return response.data!;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  void _validateResponse(Response<dynamic> response) {
    if (response.statusCode! >= 400) {
      throw ApiException(
        message: 'Erreur serveur',
        statusCode: response.statusCode,
      );
    }
  }

  ApiException _handleDioError(DioException error) {
    String message = 'Une erreur est survenue';

    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        message = data['message'] ?? message;
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Délai de connexion dépassé';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Délai de réception dépassé';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Délai d\'envoi dépassé';
        break;
      case DioExceptionType.badResponse:
        message = _handleBadResponse(error.response);
        break;
      case DioExceptionType.cancel:
        message = 'Requête annulée';
        break;
      case DioExceptionType.unknown:
        message = 'Erreur réseau inconnue';
        break;
      default:
        break;
    }

    return ApiException(
      message: message,
      statusCode: error.response?.statusCode,
      originalError: error,
    );
  }

  String _handleBadResponse(Response<dynamic>? response) {
    if (response == null) return 'Erreur serveur';

    switch (response.statusCode) {
      case 400:
        return 'Requête invalide';
      case 401:
        return 'Non autorisé - Veuillez vous reconnecter';
      case 403:
        return 'Accès refusé';
      case 404:
        return 'Ressource non trouvée';
      case 500:
        return 'Erreur serveur';
      default:
        return 'Erreur ${response.statusCode}';
    }
  }
}
