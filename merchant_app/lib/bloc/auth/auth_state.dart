part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated({required String token}) =
      _Authenticated;
  const factory AuthState.failure({required String message}) = _Failure;
}
