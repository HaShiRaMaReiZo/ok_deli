import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';
import '../core/constants/app_constants.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

class AuthRepository {
  AuthRepository(this._client);
  final ApiClient _client;

  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final response = await _client.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      // Check if response data exists
      if (response.data == null) {
        throw Exception('Empty response from server');
      }

      final authResponse = AuthResponseModel.fromJson(response.data);

      // Store token
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.tokenKey, authResponse.token);
      } catch (e) {
        // Continue even if token storage fails - the login was successful
        // PrettyDioLogger will show the error if needed
      }

      return authResponse;
    } on DioException catch (e) {
      // Re-throw with better error message
      if (e.response != null) {
        // Server responded with error
        final errorMsg =
            e.response?.data?['message'] ??
            e.response?.data?['error'] ??
            'Login failed: ${e.response?.statusCode}';
        throw Exception(errorMsg);
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Unable to connect to server. Please check your internet connection.',
        );
      } else {
        throw Exception(e.message ?? 'Network error occurred');
      }
    } catch (e) {
      // Re-throw any other errors
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    // Clear token immediately
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userKey);

    // Try to notify backend (non-blocking)
    try {
      await _client
          .post(ApiEndpoints.logout)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw Exception('Logout timeout'),
          );
    } catch (e) {
      // Ignore errors - token is already cleared
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await _client.get(ApiEndpoints.me);
      return UserModel.fromJson(response.data['user']);
    } catch (e) {
      return null;
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey);
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
