import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/package/package_bloc.dart';
import '../screens/create_package_screen.dart';
import '../screens/package_details_screen.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Packages')),
      body: BlocBuilder<PackageBloc, PackageState>(
        builder: (context, state) {
          return state.when(
            initial: () {
              context.read<PackageBloc>().add(const PackageEvent.fetchRequested());
              return const Center(child: CircularProgressIndicator());
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (packages) => ListView.separated(
              itemCount: packages.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final p = packages[i];
                return ListTile(
                  title: Text(p.trackingCode),
                  subtitle: Text('${p.status} • ${p.customerName}'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => PackageDetailsScreen(package: p)),
                    );
                  },
                );
              },
            ),
            failure: (m) => Center(child: Text(m)),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const CreatePackageScreen()),
          );
          if (created == true && context.mounted) {
            context.read<PackageBloc>().add(const PackageEvent.fetchRequested());
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
