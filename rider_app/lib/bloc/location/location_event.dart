part of 'location_bloc.dart';

@freezed
class LocationEvent with _$LocationEvent {
  const factory LocationEvent.start({required int? packageId}) = _Start;
  const factory LocationEvent.stop() = _Stop;
  const factory LocationEvent.errorOccurred(String error) = _ErrorOccurred;
}
