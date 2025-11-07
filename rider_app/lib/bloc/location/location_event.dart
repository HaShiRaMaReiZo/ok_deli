part of 'location_bloc.dart';

@freezed
class LocationEvent with _$LocationEvent {
  const factory LocationEvent.start({required double lat, required double lng, int? packageId}) = _Start;
  const factory LocationEvent.stop() = _Stop;
}
