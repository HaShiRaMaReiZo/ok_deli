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
    return data.map((e) {
      try {
        return Package.fromJson(_camelize(e as Map<String, dynamic>));
      } catch (error) {
        // Log the error for debugging
        print('Error parsing package: $error');
        print('Package data: $e');
        rethrow;
      }
    }).toList();
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
    // Return full response including package status and is_live flag
    return json as Map<String, dynamic>?;
  }

  Future<Map<String, dynamic>> bulkCreate(
    List<Map<String, dynamic>> packages,
  ) async {
    return await _service.bulkCreate(packages);
  }
}

Map<String, dynamic> _camelize(Map<String, dynamic> m) {
  // Backend returns snake_case; Freezed model expects camelCase. Map selected keys.
  // Handle null values and ensure all required fields are present
  return {
    'id': m['id'] ?? 0,
    'trackingCode': m['tracking_code'] ?? '',
    'merchantId': m['merchant_id'] ?? 0,
    'customerName': m['customer_name'] ?? '',
    'customerPhone': m['customer_phone'] ?? '',
    'customerEmail': m['customer_email'],
    'deliveryAddress': m['delivery_address'] ?? '',
    'deliveryLatitude': m['delivery_latitude'] != null
        ? ((m['delivery_latitude'] as num?)?.toDouble())
        : null,
    'deliveryLongitude': m['delivery_longitude'] != null
        ? ((m['delivery_longitude'] as num?)?.toDouble())
        : null,
    'paymentType': m['payment_type'] ?? 'cod',
    'amount': _parseAmount(m['amount']), // Returns double, which is a num
    'packageImage': m['package_image'],
    'packageDescription': m['package_description'],
    'status': m['status'] ?? 'registered',
    'currentRiderId': m['current_rider_id'],
    'assignedAt': _parseDate(m['assigned_at']),
    'pickedUpAt': _parseDate(m['picked_up_at']),
    'deliveredAt': _parseDate(m['delivered_at']),
    'deliveryAttempts': m['delivery_attempts'] ?? 0,
    'deliveryNotes': m['delivery_notes'],
  };
}

String? _parseDate(dynamic v) {
  if (v == null) return null;
  // If it's already a DateTime, convert to ISO string
  if (v is DateTime) {
    return v.toIso8601String();
  }
  // If it's a string, try to parse it first to validate, then return as-is
  final dateTime = DateTime.tryParse(v.toString());
  if (dateTime != null) {
    return dateTime.toIso8601String();
  }
  // If parsing fails, return the original string
  return v.toString();
}

double _parseAmount(dynamic v) {
  if (v == null) return 0.0;
  if (v is num) return v.toDouble();
  if (v is String) {
    return double.tryParse(v) ?? 0.0;
  }
  return 0.0;
}
