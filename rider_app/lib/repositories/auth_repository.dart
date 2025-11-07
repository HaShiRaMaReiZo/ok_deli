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
    final client = ApiClient.create(baseUrl: ApiEndpoints.baseUrl, token: token);
    final service = AuthService(client);
    return AuthRepository._(prefs, client, service);
  }

  String? get token => _prefs.getString(_tokenKey);
  ApiClient get client => _client;

  Future<String> login({required String email, required String password}) async {
    final data = await _service.login(email: email, password: password);
    final token = data['token'] as String;
    await _prefs.setString(_tokenKey, token);
    return token;
  }

  Future<void> logout() async {
    try { await _service.logout(); } finally { await _prefs.remove(_tokenKey); }
  }
}
