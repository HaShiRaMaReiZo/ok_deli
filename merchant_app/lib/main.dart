import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'repositories/auth_repository.dart';
import 'repositories/package_repository.dart';
import 'services/package_service.dart';
import 'services/websocket_service.dart';
import 'services/notification_service.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/package/package_bloc.dart';
import 'bloc/websocket/websocket_bloc.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';

// Background message handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages here
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (optional - only if Firebase is configured)
  try {
    await Firebase.initializeApp();
    // Set background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {
    // Firebase not configured, continue without it
  }

  final authRepo = await AuthRepository.create();
  final authedClient = authRepo.client;
  final packageRepo = PackageRepository(PackageService(authedClient));

  // Initialize WebSocket service (will only connect if Pusher is configured)
  final wsService = WebSocketService(
    token: authRepo.token ?? '',
    // Pusher key and cluster should come from environment/config
    // For now, leave empty to disable WebSocket features
  );

  // Initialize Notification service (will only work if Firebase is configured)
  NotificationService? notificationService;
  try {
    notificationService = NotificationService(apiClient: authedClient);
    if (authRepo.token != null) {
      await notificationService.initialize();
    }
  } catch (e) {
    // Firebase not configured, continue without notifications
  }

  runApp(
    MerchantApp(
      authRepository: authRepo,
      packageRepository: packageRepo,
      webSocketService: wsService,
      notificationService: notificationService,
    ),
  );
}

class MerchantApp extends StatelessWidget {
  const MerchantApp({
    super.key,
    required this.authRepository,
    required this.packageRepository,
    required this.webSocketService,
    this.notificationService,
  });

  final AuthRepository authRepository;
  final PackageRepository packageRepository;
  final WebSocketService webSocketService;
  final NotificationService? notificationService;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: packageRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc(repository: authRepository)),
          BlocProvider(
            create: (_) => PackageBloc(repository: packageRepository),
          ),
          BlocProvider(create: (_) => WebSocketBloc(service: webSocketService)),
        ],
        child: MaterialApp(
          title: 'Merchant',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          ),
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return state.when(
                unauthenticated: () => const LoginScreen(),
                loading: () => const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
                authenticated: (_) => const MainScreen(),
                failure: (_) => const LoginScreen(),
              );
            },
          ),
        ),
      ),
    );
  }
}
