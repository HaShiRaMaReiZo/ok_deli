import '../core/api_client.dart';
import '../services/package_service.dart';
import '../models/package.dart';

class PackageRepository {
  PackageRepository(this._service);
  final PackageService _service;

  Future<List<Package>> list({int page = 1}) async {
    final json = await _service.list(page: page);
    final data =
        json['data'] as List<dynamic>? ??
        json['packages'] as List<dynamic>? ??
        [];
    return data
        .map((e) => Package.fromJson(_camelize(e as Map<String, dynamic>)))
        .toList();
  }

  Future<Package> create(
    Map<String, dynamic> payload, {
    String? imagePath,
  }) async {
    final json = await _service.create(payload, imagePath: imagePath);
    final pkg = json['package'] as Map<String, dynamic>? ?? json;
    return Package.fromJson(_camelize(pkg));
  }

  Future<List<Map<String, dynamic>>> trackHistory(int id) async {
    final json = await _service.track(id);
    final history =
        json['status_history'] as List<dynamic>? ??
        json as List<dynamic>? ??
        [];
    return history.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>?> liveLocation(int id) async {
    final json = await _service.liveLocation(id);
    return json['rider'] as Map<String, dynamic>?;
  }
}

Map<String, dynamic> _camelize(Map<String, dynamic> m) {
  // Backend returns snake_case; Freezed model expects camelCase. Map selected keys.
  return {
    'id': m['id'],
    'trackingCode': m['tracking_code'],
    'merchantId': m['merchant_id'],
    'customerName': m['customer_name'],
    'customerPhone': m['customer_phone'],
    'customerEmail': m['customer_email'],
    'deliveryAddress': m['delivery_address'],
    'deliveryLatitude': (m['delivery_latitude'] as num?)?.toDouble(),
    'deliveryLongitude': (m['delivery_longitude'] as num?)?.toDouble(),
    'paymentType': m['payment_type'],
    'amount': (m['amount'] as num).toDouble(),
    'packageImage': m['package_image'],
    'packageDescription': m['package_description'],
    'status': m['status'],
    'currentRiderId': m['current_rider_id'],
    'assignedAt': _parseDate(m['assigned_at']),
    'pickedUpAt': _parseDate(m['picked_up_at']),
    'deliveredAt': _parseDate(m['delivered_at']),
    'deliveryAttempts': m['delivery_attempts'],
    'deliveryNotes': m['delivery_notes'],
  };
}

DateTime? _parseDate(dynamic v) {
  if (v == null) return null;
  return DateTime.tryParse(v.toString());
}
