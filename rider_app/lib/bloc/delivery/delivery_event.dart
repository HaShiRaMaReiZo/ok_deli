part of 'delivery_bloc.dart';

@freezed
class DeliveryEvent with _$DeliveryEvent {
  const factory DeliveryEvent.receiveFromOffice({
    required int packageId,
    String? notes,
  }) = _ReceiveFromOffice;
  const factory DeliveryEvent.startDelivery({required int packageId}) =
      _StartDelivery;
  const factory DeliveryEvent.updateStatus({
    required int packageId,
    required String status,
    String? notes,
    double? lat,
    double? lng,
  }) = _UpdateStatus;
  const factory DeliveryEvent.contactCustomer({
    required int packageId,
    required bool success,
    String? notes,
  }) = _ContactCustomer;
  const factory DeliveryEvent.collectCod({
    required int packageId,
    required double amount,
    String? imagePath,
  }) = _CollectCod;
}
