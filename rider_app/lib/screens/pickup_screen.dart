import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/assignments/assignments_bloc.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/empty_state_widget.dart';

class PickupScreen extends StatelessWidget {
  const PickupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pickup'), elevation: 0),
      body: BlocBuilder<AssignmentsBloc, AssignmentsState>(
        builder: (context, state) {
          return state.when(
            loading: () => const AppLoadingWidget(
              message: 'Loading pickup assignments...',
            ),
            loaded: (assignments) {
              // Filter assignments for pickup (status: assigned_to_rider for pickup from merchant)
              // Pickup assignments are those that are assigned_to_rider and need to be picked up from merchant
              // Exclude assigned_to_rider packages that are for delivery (previous status was arrived_at_office)
              final pickupAssignments = assignments.where((a) {
                final status = a['status']?.toString() ?? 'unknown';

                // Only show assigned_to_rider packages
                if (status != 'assigned_to_rider') {
                  return false;
                }

                // Check status history to see if previous status was registered (pickup) or arrived_at_office (delivery)
                final statusHistory =
                    a['status_history'] as List<dynamic>? ?? [];
                if (statusHistory.isNotEmpty) {
                  // Sort by created_at desc and check the second entry (skip current assigned_to_rider)
                  final sortedHistory =
                      List<Map<String, dynamic>>.from(statusHistory)
                        ..sort((a, b) {
                          final aTime =
                              DateTime.tryParse(
                                a['created_at']?.toString() ?? '',
                              ) ??
                              DateTime(1970);
                          final bTime =
                              DateTime.tryParse(
                                b['created_at']?.toString() ?? '',
                              ) ??
                              DateTime(1970);
                          return bTime.compareTo(aTime);
                        });

                  // If previous status was arrived_at_office, it's a delivery assignment (not pickup)
                  if (sortedHistory.length > 1) {
                    final previousStatus = sortedHistory[1]['status']
                        ?.toString();
                    return previousStatus != 'arrived_at_office';
                  }
                }

                // Default: show as pickup if we can't determine
                return true;
              }).toList();

              // Group by merchant
              final Map<int, List<dynamic>> groupedByMerchant = {};
              for (var assignment in pickupAssignments) {
                final merchantId = assignment['merchant_id'] as int?;
                if (merchantId != null) {
                  if (!groupedByMerchant.containsKey(merchantId)) {
                    groupedByMerchant[merchantId] = [];
                  }
                  groupedByMerchant[merchantId]!.add(assignment);
                }
              }

              if (groupedByMerchant.isEmpty) {
                return const EmptyStateWidget(
                  icon: Icons.inventory,
                  title: 'No packages assigned for pickup',
                  message: 'Packages assigned for pickup will appear here',
                );
              }

              return _PickupListWidget(groupedByMerchant: groupedByMerchant);
            },
            failure: (message) => AppErrorWidget(
              message: message,
              title: 'Error Loading Assignments',
              icon: Icons.error_outline,
              onRetry: () {
                context.read<AssignmentsBloc>().add(
                  const AssignmentsEvent.fetchRequested(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _PickupListWidget extends StatelessWidget {
  const _PickupListWidget({required this.groupedByMerchant});

  final Map<int, List<dynamic>> groupedByMerchant;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AssignmentsBloc>().add(
          const AssignmentsEvent.fetchRequested(),
        );
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: groupedByMerchant.length,
        itemBuilder: (context, index) {
          final merchantId = groupedByMerchant.keys.elementAt(index);
          final packages = groupedByMerchant[merchantId]!;

          // Get merchant info from first package
          final firstPackage = packages.first;
          final merchantName =
              firstPackage['merchant']?['business_name']?.toString() ??
              firstPackage['merchant_name']?.toString() ??
              'Unknown Merchant';
          final merchantAddress =
              firstPackage['merchant']?['business_address']?.toString() ??
              firstPackage['merchant_address']?.toString() ??
              'Address not available';
          final merchantPhone =
              firstPackage['merchant']?['business_phone']?.toString() ??
              firstPackage['merchant_phone']?.toString() ??
              'Phone not available';

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ExpansionTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.store, color: Colors.orange, size: 24),
              ),
              title: Text(
                merchantName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    '$merchantAddress',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  Text(
                    '${packages.length} package${packages.length > 1 ? 's' : ''} to pick up',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Merchant', merchantName),
                      _buildInfoRow('Address', merchantAddress),
                      _buildInfoRow('Phone', merchantPhone, isPhone: true),
                      const Divider(height: 24),
                      const Text(
                        'Packages to Pick Up:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...packages.map((package) => _buildPackageItem(package)),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _confirmPickup(context, merchantId),
                          icon: const Icon(Icons.check_circle),
                          label: const Text('Confirm Pickup'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isPhone = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: isPhone
                ? InkWell(
                    onTap: () async {
                      final uri = Uri.parse('tel:$value');
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      }
                    },
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                : Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageItem(dynamic package) {
    final trackingCode = package['tracking_code']?.toString() ?? 'N/A';
    final customerName = package['customer_name']?.toString() ?? 'N/A';
    final address = package['delivery_address']?.toString() ?? 'N/A';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            trackingCode,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 4),
          Text('Customer: $customerName'),
          Text(
            'Delivery: $address',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Future<void> _confirmPickup(BuildContext context, int merchantId) async {
    try {
      // Get current location
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      } catch (e) {
        // Location permission not granted or error
      }

      // Call API to confirm pickup
      final repository = context.read<AssignmentsBloc>().repository;

      await repository.confirmPickupByMerchant(
        merchantId,
        notes: 'Pickup confirmed from merchant',
        latitude: position?.latitude,
        longitude: position?.longitude,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pickup confirmed successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh assignments
        context.read<AssignmentsBloc>().add(
          const AssignmentsEvent.fetchRequested(),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error confirming pickup: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
