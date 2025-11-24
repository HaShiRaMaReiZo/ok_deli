import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  ApiClient(this._dio);
  final Dio _dio;

  factory ApiClient.create({required String baseUrl, String? token}) {
    // Function to get token dynamically from SharedPreferences
    Future<String?> getToken() async {
      try {
        final prefs = await SharedPreferences.getInstance();
        const tokenKey = 'auth_token';
        final token = prefs.getString(tokenKey);
        if (kDebugMode && token != null) {
          print('ApiClient: Token found in SharedPreferences');
        }
        return token;
      } catch (e) {
        // If SharedPreferences is not available yet, return null
        // This can happen during app initialization
        if (kDebugMode) {
          print('ApiClient: SharedPreferences not available yet: $e');
        }
        return null;
      }
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
        contentType: 'application/json',
        followRedirects: true,
        maxRedirects: 5,
      ),
    );

    // Add request interceptor to handle token dynamically
    dio.interceptors.insert(
      0,
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final currentToken = await getToken();
          if (currentToken != null && currentToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $currentToken';
          } else {
            options.headers.remove('Authorization');
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          final errorMessage = _extractErrorMessage(error);
          final customError = DioException(
            requestOptions: error.requestOptions,
            response: error.response,
            type: error.type,
            error: errorMessage,
          );
          return handler.reject(customError);
        },
      ),
    );

    // Add Pretty Dio Logger for debug mode only
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          compact: false, // Set to false for better readability
          maxWidth: 120,
        ),
      );
    }

    return ApiClient(dio);
  }

  static String _extractErrorMessage(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map<String, dynamic>) {
        return data['message'] ?? data['error'] ?? 'An error occurred';
      }
      if (data is String) {
        return data;
      }
    }
    return error.message ?? 'Network error occurred';
  }

  Dio get raw => _dio;

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.post(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.put(path, data: data, queryParameters: queryParameters);
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.delete(path, queryParameters: queryParameters);
  }
}
