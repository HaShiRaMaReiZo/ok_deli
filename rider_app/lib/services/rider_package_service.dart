import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../core/api_endpoints.dart';

class RiderPackageService {
  RiderPackageService(this._client);
  final ApiClient _client;

  Future<List<dynamic>> list() async {
    final res = await _client.raw.get(ApiEndpoints.riderPackages);
    return (res.data as List<dynamic>? ??
        res.data['data'] as List<dynamic>? ??
        []);
  }

  Future<void> updateStatus(
    int id,
    String status, {
    String? notes,
    double? lat,
    double? lng,
  }) async {
    await _client.raw.put(
      ApiEndpoints.riderStatus(id),
      data: {
        'status': status,
        if (notes != null) 'notes': notes,
        if (lat != null) 'latitude': lat,
        if (lng != null) 'longitude': lng,
      },
    );
  }

  Future<void> receiveFromOffice(int id, {String? notes}) async {
    await _client.raw.post(
      ApiEndpoints.riderReceiveFromOffice(id),
      data: {if (notes != null) 'notes': notes},
    );
  }

  Future<void> startDelivery(int id) async {
    await _client.raw.post(ApiEndpoints.riderStart(id));
  }

  Future<void> contactCustomer(
    int id, {
    required bool success,
    String? notes,
  }) async {
    await _client.raw.post(
      ApiEndpoints.riderContact(id),
      data: {
        'contact_result': success ? 'success' : 'failed',
        if (notes != null) 'notes': notes,
      },
    );
  }

  Future<void> collectCod(
    int id, {
    required double amount,
    String? imagePath,
  }) async {
    if (imagePath != null) {
      final formData = FormData.fromMap({
        'amount': amount,
        'collection_proof': await MultipartFile.fromFile(imagePath),
      });
      await _client.raw.post(ApiEndpoints.riderCod(id), data: formData);
    } else {
      await _client.raw.post(
        ApiEndpoints.riderCod(id),
        data: {'amount': amount},
      );
    }
  }

  Future<void> confirmPickupByMerchant(
    int merchantId, {
    String? notes,
    double? latitude,
    double? longitude,
  }) async {
    await _client.raw.post(
      '/api/rider/merchants/$merchantId/confirm-pickup',
      data: {
        if (notes != null) 'notes': notes,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      },
    );
  }
}
