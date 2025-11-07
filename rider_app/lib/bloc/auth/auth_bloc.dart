import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.repository}) : super(const AuthState.unauthenticated()) {
    on<_LoginRequested>((event, emit) async {
      emit(const AuthState.loading());
      try {
        final token = await repository.login(email: event.email, password: event.password);
        emit(AuthState.authenticated(token: token));
      } catch (e) {
        emit(AuthState.failure(message: e.toString()));
        emit(const AuthState.unauthenticated());
      }
    });

    on<_LogoutRequested>((event, emit) async {
      try { await repository.logout(); } finally { emit(const AuthState.unauthenticated()); }
    });
  }

  final AuthRepository repository;
}
