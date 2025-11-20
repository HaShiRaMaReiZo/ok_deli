import '../services/rider_package_service.dart';

class RiderPackageRepository {
  RiderPackageRepository(this._service);
  final RiderPackageService _service;

  Future<List<Map<String, dynamic>>> list() async {
    final data = await _service.list();
    return data.cast<Map<String, dynamic>>();
  }

  Future<void> receiveFromOffice(int id, {String? notes}) =>
      _service.receiveFromOffice(id, notes: notes);
  Future<void> startDelivery(int id) => _service.startDelivery(id);
  Future<void> updateStatus(
    int id,
    String status, {
    String? notes,
    double? lat,
    double? lng,
  }) => _service.updateStatus(id, status, notes: notes, lat: lat, lng: lng);
  Future<void> contactCustomer(
    int id, {
    required bool success,
    String? notes,
  }) => _service.contactCustomer(id, success: success, notes: notes);
  Future<void> collectCod(
    int id, {
    required double amount,
    String? imagePath,
  }) => _service.collectCod(id, amount: amount, imagePath: imagePath);

  Future<void> confirmPickupByMerchant(
    int merchantId, {
    String? notes,
    double? latitude,
    double? longitude,
  }) => _service.confirmPickupByMerchant(
    merchantId,
    notes: notes,
    latitude: latitude,
    longitude: longitude,
  );
}
