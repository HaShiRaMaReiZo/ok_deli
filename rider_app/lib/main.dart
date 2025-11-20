import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'repositories/auth_repository.dart';
import 'repositories/rider_package_repository.dart';
import 'services/rider_package_service.dart';
import 'services/location_service.dart';
import 'services/notification_service.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/assignments/assignments_bloc.dart';
import 'bloc/delivery/delivery_bloc.dart';
import 'bloc/location/location_bloc.dart';
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
  final client = authRepo.client;
  final riderRepo = RiderPackageRepository(RiderPackageService(client));
  final locationService = LocationService(client);

  // Initialize Notification service (will only work if Firebase is configured)
  NotificationService? notificationService;
  try {
    notificationService = NotificationService(apiClient: client);
    if (authRepo.token != null) {
      await notificationService.initialize();
    }
  } catch (e) {
    // Firebase not configured, continue without notifications
  }

  runApp(
    RiderApp(
      authRepository: authRepo,
      riderPackageRepository: riderRepo,
      locationService: locationService,
      notificationService: notificationService,
    ),
  );
}

class RiderApp extends StatelessWidget {
  const RiderApp({
    super.key,
    required this.authRepository,
    required this.riderPackageRepository,
    required this.locationService,
    this.notificationService,
  });

  final AuthRepository authRepository;
  final RiderPackageRepository riderPackageRepository;
  final LocationService locationService;
  final NotificationService? notificationService;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: riderPackageRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc(repository: authRepository)),
          BlocProvider(
            create: (_) =>
                AssignmentsBloc(repository: riderPackageRepository)
                  ..add(const AssignmentsEvent.fetchRequested()),
          ),
          BlocProvider(
            create: (_) => DeliveryBloc(repository: riderPackageRepository),
          ),
          BlocProvider(create: (_) => LocationBloc(service: locationService)),
        ],
        child: MaterialApp(
          title: 'Rider',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
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
