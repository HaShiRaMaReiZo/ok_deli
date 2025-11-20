import 'package:flutter/foundation.dart';
import '../core/api_client.dart';
import '../core/api_endpoints.dart';

class LocationService {
  LocationService(this._client);
  final ApiClient _client;

  Future<void> update({
    required double latitude,
    required double longitude,
    int? packageId,
    double? speed,
    double? heading,
  }) async {
    try {
      debugPrint(
        'LocationService: Sending location update to ${ApiEndpoints.riderLocation}',
      );
      debugPrint(
        'LocationService: Data: lat=$latitude, lng=$longitude, packageId=$packageId',
      );

      final response = await _client.raw.post(
        ApiEndpoints.riderLocation,
        data: {
          'latitude': latitude,
          'longitude': longitude,
          if (packageId != null) 'package_id': packageId,
          if (speed != null) 'speed': speed,
          if (heading != null) 'heading': heading,
        },
      );

      debugPrint('LocationService: Response status: ${response.statusCode}');
      if (kDebugMode) {
        debugPrint('Location update sent successfully: $latitude, $longitude');
      }
    } catch (e, stackTrace) {
      // Log error but don't throw - location tracking should continue
      debugPrint('LocationService: Location update failed: $e');
      debugPrint('LocationService: Stack trace: $stackTrace');
      // Re-throw so the bloc can handle it
      rethrow;
    }
  }
}
