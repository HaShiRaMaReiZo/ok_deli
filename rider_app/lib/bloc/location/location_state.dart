part of 'location_bloc.dart';

@freezed
class LocationState with _$LocationState {
  const factory LocationState.idle() = _Idle;
  const factory LocationState.active() = _Active;
}
