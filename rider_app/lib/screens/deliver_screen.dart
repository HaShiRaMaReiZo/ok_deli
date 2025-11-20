import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../bloc/assignments/assignments_bloc.dart';
import '../bloc/delivery/delivery_bloc.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/full_image_viewer.dart';
import 'date_packages_screen.dart';

class DeliverScreen extends StatelessWidget {
  const DeliverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deliver'), elevation: 0),
      body: BlocListener<DeliveryBloc, DeliveryState>(
        listener: (context, deliveryState) {
          // Refresh assignments when delivery actions succeed
          deliveryState.when(
            idle: () {},
            loading: () {},
            success: (_) {
              // Refresh assignments list after successful delivery action
              context.read<AssignmentsBloc>().add(
                const AssignmentsEvent.fetchRequested(),
              );
            },
            failure: (_) {},
          );
        },
        child: BlocBuilder<AssignmentsBloc, AssignmentsState>(
          builder: (context, state) {
            return state.when(
              loading: () =>
                  const AppLoadingWidget(message: 'Loading assignments...'),
              loaded: (assignments) {
                // Filter assignments for delivery
                // Delivery assignments include:
                // - assigned_to_rider: Assigned for delivery, rider needs to receive from office
                // - ready_for_delivery: Received from office, ready to start delivery
                // - on_the_way: Currently being delivered
                final deliveryAssignments = assignments.where((a) {
                  final status = a['status']?.toString() ?? 'unknown';

                  // Check if assigned_to_rider is for delivery (not pickup)
                  if (status == 'assigned_to_rider') {
                    // Check status history to see if previous status was arrived_at_office
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

                      // Check if there's an arrived_at_office status before the assigned_to_rider
                      if (sortedHistory.length > 1) {
                        final previousStatus = sortedHistory[1]['status']
                            ?.toString();
                        return previousStatus == 'arrived_at_office';
                      }
                    }
                    return false; // If no history, assume it's pickup
                  }

                  // For delivery, we want packages that are ready_for_delivery or on_the_way
                  // Also include cancelled packages (rider needs to return them)
                  // contact_failed packages are automatically reassigned (status becomes arrived_at_office)
                  return status == 'ready_for_delivery' ||
                      status == 'on_the_way' ||
                      status == 'cancelled';
                }).toList();

                if (deliveryAssignments.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.local_shipping,
                    title: 'No packages assigned for delivery',
                    message: 'Packages ready for delivery will appear here',
                  );
                }

                return _DeliverListWidget(assignments: deliveryAssignments);
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
      ),
    );
  }
}

class _DeliverListWidget extends StatelessWidget {
  const _DeliverListWidget({required this.assignments});

  final List<dynamic> assignments;

  @override
  Widget build(BuildContext context) {
    // Group assignments by assigned_at date
    final Map<String, List<dynamic>> groupedByDate = {};

    for (var assignment in assignments) {
      // Get assigned_at date, fallback to created_at if assigned_at is null
      final assignedAtStr =
          assignment['assigned_at']?.toString() ??
          assignment['created_at']?.toString();

      if (assignedAtStr != null) {
        try {
          final assignedAt = DateTime.parse(assignedAtStr);
          // Format date as YYYY-MM-DD for grouping
          final dateKey =
              '${assignedAt.year}-${assignedAt.month.toString().padLeft(2, '0')}-${assignedAt.day.toString().padLeft(2, '0')}';

          if (!groupedByDate.containsKey(dateKey)) {
            groupedByDate[dateKey] = [];
          }
          groupedByDate[dateKey]!.add(assignment);
        } catch (e) {
          // If date parsing fails, use a default date
          final dateKey = 'Unknown';
          if (!groupedByDate.containsKey(dateKey)) {
            groupedByDate[dateKey] = [];
          }
          groupedByDate[dateKey]!.add(assignment);
        }
      } else {
        // If no date, use "Unknown"
        const dateKey = 'Unknown';
        if (!groupedByDate.containsKey(dateKey)) {
          groupedByDate[dateKey] = [];
        }
        groupedByDate[dateKey]!.add(assignment);
      }
    }

    // Sort dates in descending order (newest first)
    final sortedDates = groupedByDate.keys.toList()
      ..sort((a, b) {
        if (a == 'Unknown') return 1;
        if (b == 'Unknown') return -1;
        return b.compareTo(a); // Descending order
      });

    return _DateGroupedListContent(
      groupedByDate: groupedByDate,
      sortedDates: sortedDates,
    );
  }
}

// Date-grouped list content
class _DateGroupedListContent extends StatefulWidget {
  const _DateGroupedListContent({
    required this.groupedByDate,
    required this.sortedDates,
  });

  final Map<String, List<dynamic>> groupedByDate;
  final List<String> sortedDates;

  @override
  State<_DateGroupedListContent> createState() =>
      _DateGroupedListContentState();
}

class _DateGroupedListContentState extends State<_DateGroupedListContent> {
  String _formatDate(String dateKey) {
    if (dateKey == 'Unknown') return 'Unknown Date';
    try {
      final parts = dateKey.split('-');
      if (parts.length == 3) {
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);
        // Format as DD.MM.YYYY
        return '${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}.${year}';
      }
    } catch (e) {
      // If parsing fails, return as is
    }
    return dateKey;
  }

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
        itemCount: widget.sortedDates.length,
        itemBuilder: (context, index) {
          final dateKey = widget.sortedDates[index];
          final packages = widget.groupedByDate[dateKey]!;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DatePackagesScreen(
                      dateKey: dateKey,
                      packages: packages,
                    ),
                  ),
                );
              },
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: Colors.blue,
                  size: 24,
                ),
              ),
              title: Text(
                _formatDate(dateKey),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${packages.length} package${packages.length != 1 ? 's' : ''}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    );
  }
}

// Extract the list content from assignments_screen.dart
class _AssignmentsListContent extends StatefulWidget {
  const _AssignmentsListContent({required this.assignments});

  final List<dynamic> assignments;

  @override
  State<_AssignmentsListContent> createState() =>
      _AssignmentsListContentState();
}

class _AssignmentsListContentState extends State<_AssignmentsListContent> {
  final _searchController = TextEditingController();
  String _statusFilter = 'all';

  Color _getStatusColor(String status) {
    switch (status) {
      case 'delivered':
        return Colors.green;
      case 'on_the_way':
        return Colors.blue;
      case 'ready_for_delivery':
        return Colors.teal;
      case 'picked_up':
        return Colors.purple;
      case 'assigned_to_rider':
        return Colors.orange;
      case 'contact_failed':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      case 'return_to_office':
        return Colors.amber;
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
      case 'ready_for_delivery':
        return Icons.inventory_2;
      case 'picked_up':
        return Icons.inventory;
      case 'assigned_to_rider':
        return Icons.assignment;
      case 'contact_failed':
        return Icons.phone_disabled;
      case 'cancelled':
        return Icons.cancel;
      case 'return_to_office':
        return Icons.assignment_return;
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

  List<dynamic> get _filteredAssignments {
    var filtered = widget.assignments;

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((a) {
        final trackingCode = a['tracking_code']?.toString().toLowerCase() ?? '';
        final customerName = a['customer_name']?.toString().toLowerCase() ?? '';
        final address = a['delivery_address']?.toString().toLowerCase() ?? '';
        return trackingCode.contains(query) ||
            customerName.contains(query) ||
            address.contains(query);
      }).toList();
    }

    // Apply status filter
    if (_statusFilter != 'all') {
      filtered = filtered.where((a) {
        return a['status']?.toString() == _statusFilter;
      }).toList();
    }

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredAssignments;

    return Column(
      children: [
        // Search and filter bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by tracking code, customer, or address...',
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
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('all', 'All'),
                    _buildFilterChip('assigned_to_rider', 'Assigned'),
                    _buildFilterChip('ready_for_delivery', 'Ready'),
                    _buildFilterChip('on_the_way', 'On the Way'),
                    _buildFilterChip('picked_up', 'Picked Up'), // Legacy
                  ],
                ),
              ),
            ],
          ),
        ),
        // List
        Expanded(
          child: filtered.isEmpty
              ? const EmptyStateWidget(
                  icon: Icons.search_off,
                  title: 'No assignments found',
                  message: 'Try adjusting your search or filters',
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    context.read<AssignmentsBloc>().add(
                      const AssignmentsEvent.fetchRequested(),
                    );
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final a = filtered[i];
                      return _buildAssignmentCard(context, a);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _statusFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _statusFilter = value;
          });
        },
      ),
    );
  }

  Widget _buildAssignmentCard(BuildContext context, dynamic a) {
    final id = a['id'] as int? ?? a['package_id'] as int? ?? 0;
    final status = a['status']?.toString() ?? 'unknown';
    final trackingCode = a['tracking_code']?.toString() ?? 'N/A';
    final customerName = a['customer_name']?.toString() ?? 'N/A';
    final customerPhone = a['customer_phone']?.toString() ?? 'N/A';
    final address = a['delivery_address']?.toString() ?? 'N/A';
    final packageImage = a['package_image']?.toString();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getStatusColor(status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getStatusIcon(status),
            color: _getStatusColor(status),
            size: 24,
          ),
        ),
        title: Text(
          trackingCode,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              customerName,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              _formatStatus(status),
              style: TextStyle(
                color: _getStatusColor(status),
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
                _buildInfoRow('Customer', customerName),
                _buildInfoRow('Phone', customerPhone, isPhone: true),
                _buildInfoRow('Address', address),
                if (packageImage != null) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Package Image',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      FullImageViewer.show(
                        context,
                        packageImage,
                        title: 'Package Image',
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          Image.network(
                            packageImage,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 150,
                                color: Colors.grey[300],
                                child: const Center(child: Icon(Icons.error)),
                              );
                            },
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.fullscreen,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                _buildActionButtons(context, id, status),
              ],
            ),
          ),
        ],
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

  Widget _buildActionButtons(BuildContext context, int id, String status) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // For assigned_to_rider (delivery assignment): rider needs to receive from office
        if (status == 'assigned_to_rider')
          ElevatedButton.icon(
            onPressed: () {
              context.read<DeliveryBloc>().add(
                DeliveryEvent.receiveFromOffice(packageId: id),
              );
            },
            icon: const Icon(Icons.check_circle),
            label: const Text('Receive from Office'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          ),
        // For ready_for_delivery: rider can start delivery
        if (status == 'ready_for_delivery')
          ElevatedButton.icon(
            onPressed: () {
              context.read<DeliveryBloc>().add(
                DeliveryEvent.startDelivery(packageId: id),
              );
            },
            icon: const Icon(Icons.local_shipping),
            label: const Text('Start Delivery'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        // Legacy: picked_up status (for backward compatibility)
        if (status == 'picked_up')
          ElevatedButton.icon(
            onPressed: () {
              context.read<DeliveryBloc>().add(
                DeliveryEvent.startDelivery(packageId: id),
              );
            },
            icon: const Icon(Icons.local_shipping),
            label: const Text('Start Delivery'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        if (status == 'on_the_way') ...[
          ElevatedButton.icon(
            onPressed: () {
              _showCodDialog(context, id);
            },
            icon: const Icon(Icons.payment),
            label: const Text('Collect COD'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {
              _showContactFailedDialog(context, id);
            },
            icon: const Icon(Icons.phone_disabled),
            label: const Text('Can\'t Contact'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
          ),
        ],
        // Return to Office button only for cancelled packages
        // contact_failed packages are automatically reassigned (no button needed)
        if (status == 'cancelled')
          ElevatedButton.icon(
            onPressed: () {
              _showReturnToOfficeDialog(context, id, status);
            },
            icon: const Icon(Icons.assignment_return),
            label: const Text('Return to Office'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
          ),
        // Cancel button (only for packages that haven't been cancelled yet)
        if (status == 'assigned_to_rider' ||
            status == 'ready_for_delivery' ||
            status == 'on_the_way')
          OutlinedButton.icon(
            onPressed: () {
              _showCancelDialog(context, id);
            },
            icon: const Icon(Icons.cancel),
            label: const Text('Cancel'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
          ),
      ],
    );
  }

  void _showReturnToOfficeDialog(
    BuildContext context,
    int id,
    String currentStatus,
  ) {
    final notesController = TextEditingController();
    // Only cancelled packages need to return to office
    final statusText = 'Cancelled';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Return to Office'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Return this $statusText package to the office?',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                hintText: 'Add any notes about returning the package...',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<DeliveryBloc>().add(
                DeliveryEvent.updateStatus(
                  packageId: id,
                  status: 'return_to_office',
                  notes: notesController.text.isNotEmpty
                      ? notesController.text
                      : 'Package returned to office',
                ),
              );
              Navigator.of(dialogContext).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, Return'),
          ),
        ],
      ),
    );
  }

  void _showContactFailedDialog(BuildContext context, int id) {
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Contact Failed'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Customer could not be contacted.'),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Reason (Required)',
                hintText: 'Please provide the reason for contact failure...',
              ),
              maxLines: 3,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (notesController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Please provide a reason for contact failure',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              context.read<DeliveryBloc>().add(
                DeliveryEvent.contactCustomer(
                  packageId: id,
                  success: false,
                  notes: notesController.text.trim(),
                ),
              );
              Navigator.of(dialogContext).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, int id) {
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel Package'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Are you sure you want to cancel this package?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Reason (Optional)',
                hintText: 'Add reason for cancellation...',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<DeliveryBloc>().add(
                DeliveryEvent.updateStatus(
                  packageId: id,
                  status: 'cancelled',
                  notes: notesController.text.isNotEmpty
                      ? notesController.text
                      : null,
                ),
              );
              Navigator.of(dialogContext).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _showCodDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final amountController = TextEditingController();
        File? proofImage;

        return StatefulBuilder(
          builder: (dialogContext, setDialogState) => AlertDialog(
            title: const Text('Collect COD'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixText: '\$',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final image = await picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (image != null) {
                      setDialogState(() {
                        proofImage = File(image.path);
                      });
                    }
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take Photo'),
                ),
                if (proofImage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Image.file(proofImage!, height: 100),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(amountController.text) ?? 0.0;
                  context.read<DeliveryBloc>().add(
                    DeliveryEvent.collectCod(
                      packageId: id,
                      amount: amount,
                      imagePath: proofImage?.path,
                    ),
                  );
                  Navigator.pop(dialogContext);
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
        );
      },
    );
  }
}
