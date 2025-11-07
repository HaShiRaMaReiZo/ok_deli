part of 'package_bloc.dart';

@freezed
class PackageEvent with _$PackageEvent {
  const factory PackageEvent.fetchRequested({int? page}) = _PackageFetchRequested;
}
