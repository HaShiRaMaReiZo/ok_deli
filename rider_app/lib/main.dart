import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/api_endpoints.dart';
import 'repositories/auth_repository.dart';
import 'repositories/rider_package_repository.dart';
import 'services/rider_package_service.dart';
import 'services/location_service.dart';
import 'core/api_client.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/assignments/assignments_bloc.dart';
import 'bloc/delivery/delivery_bloc.dart';
import 'bloc/location/location_bloc.dart';
import 'screens/login_screen.dart';
import 'screens/assignments_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authRepo = await AuthRepository.create();
  final client = authRepo.client;
  final riderRepo = RiderPackageRepository(RiderPackageService(client));
  final locationService = LocationService(client);

  runApp(RiderApp(
    authRepository: authRepo,
    riderPackageRepository: riderRepo,
    locationService: locationService,
  ));
}

class RiderApp extends StatelessWidget {
  const RiderApp({super.key, required this.authRepository, required this.riderPackageRepository, required this.locationService});

  final AuthRepository authRepository;
  final RiderPackageRepository riderPackageRepository;
  final LocationService locationService;

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
          BlocProvider(create: (_) => AssignmentsBloc(repository: riderPackageRepository)..add(const AssignmentsEvent.fetchRequested())),
          BlocProvider(create: (_) => DeliveryBloc(repository: riderPackageRepository)),
          BlocProvider(create: (_) => LocationBloc(service: locationService)),
        ],
        child: MaterialApp(
          title: 'Rider',
          theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal)),
          home: const LoginScreen(),
        ),
      ),
    );
  }
}
