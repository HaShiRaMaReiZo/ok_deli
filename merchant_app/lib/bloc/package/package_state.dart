part of 'package_bloc.dart';

@freezed
class PackageState with _$PackageState {
  const factory PackageState.initial() = _Initial;
  const factory PackageState.loading() = _Loading;
  const factory PackageState.loaded({required List<Package> packages}) = _Loaded;
  const factory PackageState.failure({required String message}) = _Failure;
}
