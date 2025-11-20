part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loginRequested({
    required String email,
    required String password,
  }) = _AuthLoginRequested;
  const factory AuthEvent.logoutRequested() = _AuthLogoutRequested;
  const factory AuthEvent.checkAuthStatus() = _AuthCheckStatus;
}
