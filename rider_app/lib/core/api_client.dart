import 'package:dio/dio.dart';

class ApiClient {
  ApiClient(this._dio);
  final Dio _dio;

  factory ApiClient.create({required String baseUrl, String? token}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
        contentType: 'application/json',
      ),
    );
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    return ApiClient(dio);
  }

  Dio get raw => _dio;
}
