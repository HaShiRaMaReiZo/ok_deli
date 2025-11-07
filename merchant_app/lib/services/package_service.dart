import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../core/api_endpoints.dart';

class PackageService {
  PackageService(this._client);
  final ApiClient _client;

  Future<Map<String, dynamic>> list({int page = 1}) async {
    final res = await _client.raw.get(
      ApiEndpoints.merchantPackages,
      queryParameters: {'page': page},
    );
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> create(
    Map<String, dynamic> payload, {
    String? imagePath,
  }) async {
    if (imagePath != null) {
      final formData = FormData.fromMap({
        ...payload,
        'package_image': await MultipartFile.fromFile(imagePath),
      });
      final res = await _client.raw.post(
        ApiEndpoints.merchantPackages,
        data: formData,
      );
      return res.data as Map<String, dynamic>;
    } else {
      final res = await _client.raw.post(
        ApiEndpoints.merchantPackages,
        data: payload,
      );
      return res.data as Map<String, dynamic>;
    }
  }

  Future<Map<String, dynamic>> track(int id) async {
    final res = await _client.raw.get(ApiEndpoints.merchantTrack(id));
    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> liveLocation(int id) async {
    final res = await _client.raw.get(ApiEndpoints.merchantLiveLocation(id));
    return res.data as Map<String, dynamic>;
  }
}
