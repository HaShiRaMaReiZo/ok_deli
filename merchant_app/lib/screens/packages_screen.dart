import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/package/package_bloc.dart';
import '../bloc/websocket/websocket_bloc.dart';
import '../screens/bulk_create_package_screen.dart';
import '../screens/package_details_screen.dart';
import '../repositories/auth_repository.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/empty_state_widget.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  final _searchController = TextEditingController();

  Color _getStatusColor(String status) {
    switch (status) {
      case 'delivered':
        return Colors.green;
      case 'on_the_way':
        return Colors.blue;
      case 'registered':
        return Colors.orange;
      case 'returned_to_office':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'delivered':
        return Icons.check_circle;
      case 'on_the_way':
        return Icons.local_shipping;
      case 'registered':
        return Icons.inventory;
      case 'returned_to_office':
        return Icons.undo;
      default:
        return Icons.pending;
    }
  }

  String _formatStatus(String status) {
    return status
        .split('_')
        .map((s) {
          return s[0].toUpperCase() + s.substring(1);
        })
        .join(' ');
  }

  @override
  void initState() {
    super.initState();
    // Setup WebSocket listener after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupWebSocket(context);
    });
  }

  void _setupWebSocket(BuildContext context) async {
    try {
      // Get merchant ID from user data
      final authRepo = context.read<AuthRepository>();
      final authService = authRepo.client.raw;
      final userResponse = await authService.get('/api/auth/user');
      final userData = userResponse.data as Map<String, dynamic>;
      final merchantId =
          userData['merchant_id'] as int? ??
          userData['merchant']?['id'] as int?;

      if (merchantId != null) {
        final wsBloc = context.read<WebSocketBloc>();
        wsBloc.add(WebSocketEvent.connect());
        wsBloc.add(WebSocketEvent.subscribeToMerchant(merchantId));

        // Listen for package status changes
        wsBloc.stream.listen((state) {
          state.when(
            disconnected: () {},
            connected: () {},
            subscribedToMerchant: (_) {},
            subscribedToPackageLocation: (_) {},
            error: (_) {},
            packageUpdateReceived: (data) {
              // Refresh packages list when status changes
              if (context.mounted) {
                context.read<PackageBloc>().add(
                  const PackageEvent.fetchRequested(),
                );
              }
            },
            riderLocationUpdateReceived: (_, __) {},
          );
        });
      }
    } catch (e) {
      // Handle error silently - WebSocket is optional
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Packages'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PackageBloc>().add(
                const PackageEvent.fetchRequested(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by tracking code or customer name...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          // Packages List
          Expanded(
            child: BlocBuilder<PackageBloc, PackageState>(
              builder: (context, state) {
                return state.when(
                  initial: () {
                    context.read<PackageBloc>().add(
                      const PackageEvent.fetchRequested(),
                    );
                    return const AppLoadingWidget(
                      message: 'Loading packages...',
                    );
                  },
                  loading: () =>
                      const AppLoadingWidget(message: 'Loading packages...'),
                  loaded: (packages) {
                    // Filter packages based on search
                    final searchQuery = _searchController.text.toLowerCase();
                    final filteredPackages = searchQuery.isEmpty
                        ? packages
                        : packages.where((p) {
                            return p.trackingCode.toLowerCase().contains(
                                  searchQuery,
                                ) ||
                                p.customerName.toLowerCase().contains(
                                  searchQuery,
                                );
                          }).toList();

                    if (filteredPackages.isEmpty) {
                      return EmptyStateWidget(
                        icon: searchQuery.isEmpty
                            ? Icons.inbox_outlined
                            : Icons.search_off,
                        title: searchQuery.isEmpty
                            ? 'No packages yet'
                            : 'No packages found',
                        message: searchQuery.isEmpty
                            ? 'Tap + to create your first package'
                            : 'Try a different search term',
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<PackageBloc>().add(
                          const PackageEvent.fetchRequested(),
                        );
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredPackages.length,
                        itemBuilder: (context, i) {
                          final p = filteredPackages[i];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        PackageDetailsScreen(package: p),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    // Status Icon
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(
                                          p.status,
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        _getStatusIcon(p.status),
                                        color: _getStatusColor(p.status),
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Package Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            p.trackingCode,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'monospace',
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            p.customerName,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(
                                                p.status,
                                              ).withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              _formatStatus(p.status),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: _getStatusColor(
                                                  p.status,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Arrow Icon
                                    Icon(
                                      Icons.chevron_right,
                                      color: Colors.grey[400],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  failure: (m) => AppErrorWidget(
                    message: m,
                    title: 'Error loading packages',
                    onRetry: () {
                      context.read<PackageBloc>().add(
                        const PackageEvent.fetchRequested(),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const BulkCreatePackageScreen()),
          );
          if (created == true && context.mounted) {
            context.read<PackageBloc>().add(
              const PackageEvent.fetchRequested(),
            );
          }
        },
        icon: const Icon(Icons.add_business),
        label: const Text('Create Packages'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
