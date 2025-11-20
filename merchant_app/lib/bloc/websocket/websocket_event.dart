part of 'websocket_bloc.dart';

@freezed
class WebSocketEvent with _$WebSocketEvent {
  const factory WebSocketEvent.connect() = _Connect;
  const factory WebSocketEvent.disconnect() = _Disconnect;
  const factory WebSocketEvent.subscribeToMerchant(int merchantId) =
      _SubscribeToMerchant;
  const factory WebSocketEvent.subscribeToPackageLocation(int packageId) =
      _SubscribeToPackageLocation;
  const factory WebSocketEvent.unsubscribeFromPackageLocation(int packageId) =
      _UnsubscribeFromPackageLocation;
  const factory WebSocketEvent.packageStatusChanged(String data) =
      _PackageStatusChanged;
  const factory WebSocketEvent.riderLocationUpdated(
    int packageId,
    String data,
  ) = _RiderLocationUpdated;
}
