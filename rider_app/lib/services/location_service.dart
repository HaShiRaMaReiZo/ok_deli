import '../core/api_client.dart';
import '../core/api_endpoints.dart';

class LocationService {
  LocationService(this._client);
  final ApiClient _client;

  Future<void> update({required double latitude, required double longitude, int? packageId, double? speed, double? heading}) async {
    await _client.raw.post(ApiEndpoints.riderLocation, data: {
      'latitude': latitude,
      'longitude': longitude,
      if (packageId != null) 'package_id': packageId,
      if (speed != null) 'speed': speed,
      if (heading != null) 'heading': heading,
    });
  }
}
