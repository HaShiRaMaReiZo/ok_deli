import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.repository}) : super(const AuthState.loading()) {
    on<_AuthCheckStatus>((event, emit) async {
      final token = repository.token;
      if (token != null && token.isNotEmpty) {
        try {
          // Verify token by calling /api/auth/user endpoint
          final userData = await repository.service.me();
          final user = userData['user'] as Map<String, dynamic>?;
          final role = user?['role'] as String?;

          // Only allow riders to use this app
          if (role != 'rider') {
            await repository.logout();
            emit(const AuthState.unauthenticated());
            return;
          }

          // Token is valid and user is a rider, restore authenticated state
          emit(AuthState.authenticated(token: token));
        } catch (e) {
          // Token is invalid or expired, clear it
          await repository.logout();
          emit(const AuthState.unauthenticated());
        }
      } else {
        emit(const AuthState.unauthenticated());
      }
    });

    // Check authentication status on initialization (after handlers are registered)
    add(const AuthEvent.checkAuthStatus());

    on<_LoginRequested>((event, emit) async {
      emit(const AuthState.loading());
      try {
        final token = await repository.login(
          email: event.email,
          password: event.password,
        );
        emit(AuthState.authenticated(token: token));
      } catch (e) {
        String errorMessage;
        if (e is DioException) {
          try {
            final responseData = e.response?.data;
            if (responseData is Map<String, dynamic>) {
              errorMessage =
                  responseData['message']?.toString() ??
                  responseData['error']?.toString() ??
                  e.message ??
                  'Login failed. Please check your credentials.';
            } else if (responseData is String) {
              errorMessage = responseData;
            } else {
              final statusCode = e.response?.statusCode;
              if (statusCode == 401 || statusCode == 422) {
                errorMessage = 'Invalid email or password. Please try again.';
              } else if (statusCode != null) {
                errorMessage =
                    'Login failed (Error $statusCode). Please try again.';
              } else {
                errorMessage =
                    e.message ?? 'Login failed. Please check your credentials.';
              }
            }
          } catch (_) {
            final statusCode = e.response?.statusCode;
            if (statusCode == 401 || statusCode == 422) {
              errorMessage = 'Invalid email or password. Please try again.';
            } else {
              errorMessage =
                  e.message ?? 'Login failed. Please check your credentials.';
            }
          }
        } else {
          errorMessage = e.toString();
        }
        emit(AuthState.failure(message: errorMessage));
        emit(const AuthState.unauthenticated());
      }
    });

    on<_LogoutRequested>((event, emit) async {
      try {
        await repository.logout();
      } finally {
        emit(const AuthState.unauthenticated());
      }
    });
  }

  final AuthRepository repository;
}
