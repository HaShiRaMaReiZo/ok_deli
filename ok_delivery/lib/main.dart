import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/api/api_client.dart';
import 'core/api/api_endpoints.dart';
import 'core/theme/app_theme.dart';
import 'repositories/auth_repository.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/auth/auth_state.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize API client
    final apiClient = ApiClient.create(baseUrl: ApiEndpoints.baseUrl);
    final authRepository = AuthRepository(apiClient);

    return MaterialApp(
      title: 'OK Delivery - Merchant',
      theme: AppTheme.lightTheme,
      home: BlocProvider(
        create: (context) => AuthBloc(authRepository)..add(AuthCheckStatus()),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            // Show loading while checking authentication status
            if (state is AuthInitial || state is AuthLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is AuthAuthenticated) {
              return MainNavigationScreen(user: state.user);
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
