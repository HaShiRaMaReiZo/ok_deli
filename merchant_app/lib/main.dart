import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repositories/auth_repository.dart';
import 'repositories/package_repository.dart';
import 'services/package_service.dart';
import 'core/api_client.dart';
import 'core/api_endpoints.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/package/package_bloc.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authRepo = await AuthRepository.create();
  final authedClient = authRepo.client;
  final packageRepo = PackageRepository(PackageService(authedClient));

  runApp(MerchantApp(authRepository: authRepo, packageRepository: packageRepo));
}

class MerchantApp extends StatelessWidget {
  const MerchantApp({
    super.key,
    required this.authRepository,
    required this.packageRepository,
  });

  final AuthRepository authRepository;
  final PackageRepository packageRepository;

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
        ],
        child: MaterialApp(
          title: 'Merchant',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          ),
          home: const LoginScreen(),
        ),
      ),
    );
  }
}
