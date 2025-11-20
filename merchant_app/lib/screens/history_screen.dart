import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/package/package_bloc.dart';
import '../screens/package_details_screen.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/empty_state_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _searchController = TextEditingController();

  Color _getStatusColor(String status) {
    switch (status) {
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'delivered':
        return Icons.check_circle;
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
    // Fetch packages on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PackageBloc>().add(const PackageEvent.fetchRequested());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivered Packages'),
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
                hintText: 'Search by customer name...',
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
                    // Filter only delivered packages
                    final deliveredPackages = packages
                        .where((p) => p.status == 'delivered')
                        .toList();

                    // Filter packages based on search (by customer name only)
                    final searchQuery = _searchController.text.toLowerCase();
                    final filteredPackages = searchQuery.isEmpty
                        ? deliveredPackages
                        : deliveredPackages.where((p) {
                            return p.customerName.toLowerCase().contains(
                              searchQuery,
                            );
                          }).toList();

                    if (filteredPackages.isEmpty) {
                      return EmptyStateWidget(
                        icon: searchQuery.isEmpty
                            ? Icons.history
                            : Icons.search_off,
                        title: searchQuery.isEmpty
                            ? 'No delivered packages yet'
                            : 'No packages found',
                        message: searchQuery.isEmpty
                            ? 'Your delivered packages will appear here'
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
    );
  }
}
