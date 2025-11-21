import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repository) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckStatus>(_onCheckStatus);
  }

  final AuthRepository _repository;

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final authResponse = await _repository.login(event.email, event.password);

      // Validate role - only merchants should use this app
      if (authResponse.user.role != 'merchant') {
        await _repository.logout();
        emit(AuthError('Only merchant accounts can access this app'));
        return;
      }

      emit(AuthAuthenticated(authResponse.user));
    } catch (e, stackTrace) {
      // Log the full error for debugging
      if (kDebugMode) {
        print('AuthBloc: Login error: $e');
        print('AuthBloc: Stack trace: $stackTrace');
      }
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      emit(AuthError(errorMessage));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _repository.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final isAuthenticated = await _repository.isAuthenticated();
    if (isAuthenticated) {
      final user = await _repository.getCurrentUser();
      if (user != null && user.role == 'merchant') {
        emit(AuthAuthenticated(user));
      } else {
        await _repository.logout();
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }
}
