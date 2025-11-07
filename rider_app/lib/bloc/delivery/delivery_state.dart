part of 'delivery_bloc.dart';

@freezed
class DeliveryState with _$DeliveryState {
  const factory DeliveryState.idle() = _Idle;
  const factory DeliveryState.loading() = _Loading;
  const factory DeliveryState.success({required String message}) = _Success;
  const factory DeliveryState.failure({required String message}) = _Failure;
}
