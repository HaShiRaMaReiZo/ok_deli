import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
        final saved = await prefs.setString(
          AppConstants.tokenKey,
          authResponse.token,
        );
        if (kDebugMode) {
          print('AuthRepository: Token saved successfully: $saved');
          // Verify token was saved
          final verifyToken = prefs.getString(AppConstants.tokenKey);
          print(
            'AuthRepository: Token verification: ${verifyToken != null ? "Saved" : "NOT SAVED"}',
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print('AuthRepository: ERROR saving token: $e');
        }
        // Re-throw error - token storage is critical
        throw Exception('Failed to save authentication token: $e');
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
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.tokenKey);
      if (kDebugMode) {
        print(
          'AuthRepository: Token retrieved: ${token != null ? "Found (${token.length} chars)" : "NOT FOUND"}',
        );
      }
      return token;
    } catch (e) {
      if (kDebugMode) {
        print('AuthRepository: ERROR getting token: $e');
      }
      return null;
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      return false;
    }

    // Verify token is still valid by calling /api/auth/user
    try {
      final user = await getCurrentUser();
      return user != null && user.role == 'merchant';
    } catch (e) {
      // Token is invalid or expired, clear it
      await logout();
      return false;
    }
  }
}
