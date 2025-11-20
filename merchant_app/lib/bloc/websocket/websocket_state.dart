part of 'websocket_bloc.dart';

@freezed
class WebSocketState with _$WebSocketState {
  const factory WebSocketState.disconnected() = _Disconnected;
  const factory WebSocketState.connected() = _Connected;
  const factory WebSocketState.subscribedToMerchant(int merchantId) =
      _SubscribedToMerchant;
  const factory WebSocketState.subscribedToPackageLocation(int packageId) =
      _SubscribedToPackageLocation;
  const factory WebSocketState.error(String message) = _Error;
  const factory WebSocketState.packageUpdateReceived(String data) =
      _PackageUpdateReceived;
  const factory WebSocketState.riderLocationUpdateReceived(
    int packageId,
    String data,
  ) = _RiderLocationUpdateReceived;
}
