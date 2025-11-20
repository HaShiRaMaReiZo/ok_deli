import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  factory ApiClient.create({required String baseUrl, String? token}) {
    // Function to get token dynamically from SharedPreferences
    Future<String?> getToken() async {
      final prefs = await SharedPreferences.getInstance();
      const tokenKey = 'auth_token';
      return prefs.getString(tokenKey);
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
        followRedirects: true,
        maxRedirects: 5, // Limit redirects to prevent redirect loops
        // Don't set contentType here - let Dio handle it automatically
        // For JSON requests, it will be set automatically
        // For FormData (file uploads), Dio will set multipart/form-data
      ),
    );

    // Add request interceptor to handle token and FormData Content-Type (must be FIRST)
    dio.interceptors.insert(
      0,
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Update Authorization header with latest token from SharedPreferences
          final currentToken = await getToken();
          if (currentToken != null && currentToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $currentToken';
          } else {
            options.headers.remove('Authorization');
          }

          // If data is FormData, remove Content-Type header so Dio can set it with boundary
          if (options.data is FormData) {
            // Remove Content-Type header completely
            options.headers.remove('Content-Type');
            options.headers.remove('content-type');
            // Clear contentType property
            options.contentType = null;
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

    // Add logging interceptor AFTER request interceptor
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    return ApiClient(dio);
  }

  static String _extractErrorMessage(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map<String, dynamic>) {
        // Try to get user-friendly error message
        if (data.containsKey('message')) {
          return data['message'] as String;
        }
        if (data.containsKey('error')) {
          return data['error'] as String;
        }
        if (data.containsKey('errors')) {
          final errors = data['errors'];
          if (errors is Map) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              return firstError.first as String;
            }
          }
        }
      }
    }

    // Network errors
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          return 'Authentication failed. Please login again.';
        }
        if (statusCode == 403) {
          return 'You don\'t have permission to perform this action.';
        }
        if (statusCode == 404) {
          return 'The requested resource was not found.';
        }
        if (statusCode == 422) {
          return 'Invalid data. Please check your input.';
        }
        if (statusCode != null && statusCode >= 500) {
          return 'Server error. Please try again later.';
        }
        return 'Request failed with status ${statusCode ?? 'unknown'}.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.unknown:
        // Handle redirect loop errors
        if (error.error?.toString().contains('RedirectException') == true ||
            error.error?.toString().contains('Redirect loop') == true) {
          return 'Authentication error. Please logout and login again.';
        }
        if (error.error?.toString().contains('SocketException') == true ||
            error.error?.toString().contains('Failed host lookup') == true) {
          return 'No internet connection. Please check your network.';
        }
        return error.error?.toString() ?? 'An unknown error occurred.';
      default:
        return error.message ?? 'An error occurred.';
    }
  }

  Dio get raw => _dio;
}
