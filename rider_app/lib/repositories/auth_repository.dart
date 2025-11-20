import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_client.dart';
import '../core/api_endpoints.dart';
import '../services/auth_service.dart';

class AuthRepository {
  AuthRepository._(this._prefs, this._client, this._service);

  final SharedPreferences _prefs;
  final ApiClient _client;
  final AuthService _service;

  static const _tokenKey = 'auth_token';

  static Future<AuthRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final client = ApiClient.create(
      baseUrl: ApiEndpoints.baseUrl,
      token: token,
    );
    final service = AuthService(client);
    return AuthRepository._(prefs, client, service);
  }

  String? get token => _prefs.getString(_tokenKey);
  ApiClient get client => _client;
  AuthService get service => _service;

  Future<String> login({
    required String email,
    required String password,
  }) async {
    final data = await _service.login(email: email, password: password);

    // Check if user is a rider
    final user = data['user'] as Map<String, dynamic>?;
    final role = user?['role'] as String?;

    if (role != 'rider') {
      throw Exception(
        'This app is for riders only. Please use the merchant app or office portal.',
      );
    }

    final token = data['token'] as String;
    await _prefs.setString(_tokenKey, token);
    return token;
  }

  Future<void> logout() async {
    // Clear token immediately (don't wait for API response)
    // This ensures logout works even if backend is slow or unreachable
    await _prefs.remove(_tokenKey);

    // Try to notify backend, but don't wait if it times out
    try {
      await _service.logout().timeout(const Duration(seconds: 5));
    } catch (e) {
      // Ignore errors - token is already cleared locally
      // Logout should succeed even if backend is unreachable
    }
  }
}
