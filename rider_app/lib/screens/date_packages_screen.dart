import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../bloc/assignments/assignments_bloc.dart';
import '../bloc/delivery/delivery_bloc.dart';
import '../core/api_endpoints.dart';
import '../widgets/full_image_viewer.dart';

class DatePackagesScreen extends StatefulWidget {
  const DatePackagesScreen({
    super.key,
    required this.dateKey,
    required this.packages,
  });

  final String dateKey;
  final List<dynamic> packages;

  @override
  State<DatePackagesScreen> createState() => _DatePackagesScreenState();
}

class _DatePackagesScreenState extends State<DatePackagesScreen> {
  final _searchController = TextEditingController();
  String _statusFilter = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

  List<dynamic> _filterPackages(List<dynamic> packages) {
    var filtered = packages;

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
              style: TextStyle(
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
        title: Text('Return to Office'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_formatDate(widget.dateKey)), elevation: 0),
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
          builder: (context, assignmentsState) {
            // Get packages from AssignmentsBloc or use initial packages
            List<dynamic> currentPackages = widget.packages;

            assignmentsState.when(
              loading: () {},
              loaded: (allAssignments) {
                // Filter assignments for delivery and match by date
                final deliveryAssignments = allAssignments.where((a) {
                  final status = a['status']?.toString() ?? 'unknown';

                  // Get assigned_at date
                  final assignedAtStr =
                      a['assigned_at']?.toString() ??
                      a['created_at']?.toString();

                  if (assignedAtStr != null) {
                    try {
                      final assignedAt = DateTime.parse(assignedAtStr);
                      final dateKey =
                          '${assignedAt.year}-${assignedAt.month.toString().padLeft(2, '0')}-${assignedAt.day.toString().padLeft(2, '0')}';

                      // Check if this package belongs to the current date
                      if (dateKey == widget.dateKey) {
                        // Check if assigned_to_rider is for delivery (not pickup)
                        if (status == 'assigned_to_rider') {
                          final statusHistory =
                              a['status_history'] as List<dynamic>? ?? [];
                          if (statusHistory.isNotEmpty) {
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

                            if (sortedHistory.length > 1) {
                              final previousStatus = sortedHistory[1]['status']
                                  ?.toString();
                              return previousStatus == 'arrived_at_office';
                            }
                          }
                          return false;
                        }

                        // For other statuses, include if they're delivery-related
                        // contact_failed packages are automatically reassigned (status becomes arrived_at_office)
                        return status == 'ready_for_delivery' ||
                            status == 'on_the_way' ||
                            status == 'cancelled';
                      }
                    } catch (e) {
                      // If date parsing fails, skip
                    }
                  }
                  return false;
                }).toList();

                // Update current packages with filtered ones for this date
                currentPackages = deliveryAssignments;
              },
              failure: (_) {},
            );

            final filtered = _filterPackages(currentPackages);

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
                          hintText:
                              'Search by tracking code, customer, or address...',
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
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip('all', 'All'),
                            _buildFilterChip('assigned_to_rider', 'Assigned'),
                            _buildFilterChip('ready_for_delivery', 'Ready'),
                            _buildFilterChip('on_the_way', 'On the Way'),
                            _buildFilterChip('cancelled', 'Cancelled'),
                            _buildFilterChip('picked_up', 'Picked Up'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Packages list
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No packages found',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try adjusting your search or filters',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
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
                            itemBuilder: (context, index) {
                              final a = filtered[index];
                              final id =
                                  a['id'] as int? ??
                                  a['package_id'] as int? ??
                                  0;
                              final status =
                                  a['status']?.toString() ?? 'unknown';
                              final trackingCode =
                                  a['tracking_code']?.toString() ?? 'N/A';
                              final customerName =
                                  a['customer_name']?.toString() ?? 'N/A';
                              final customerPhone =
                                  a['customer_phone']?.toString() ?? 'N/A';
                              final address =
                                  a['delivery_address']?.toString() ?? 'N/A';
                              final packageImage = a['package_image']
                                  ?.toString();

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(
                                                status,
                                              ).withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              _getStatusIcon(status),
                                              color: _getStatusColor(status),
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  trackingCode,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'monospace',
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: _getStatusColor(
                                                      status,
                                                    ).withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    _formatStatus(status),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: _getStatusColor(
                                                        status,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(height: 24),
                                      _buildInfoRow('Customer', customerName),
                                      _buildInfoRow(
                                        'Phone',
                                        customerPhone,
                                        isPhone: true,
                                      ),
                                      _buildInfoRow('Address', address),
                                      if (packageImage != null &&
                                          packageImage.isNotEmpty) ...[
                                        const SizedBox(height: 8),
                                        GestureDetector(
                                          onTap: () {
                                            final imageUrl =
                                                packageImage.startsWith('http')
                                                ? packageImage
                                                : '${ApiEndpoints.baseUrl}/storage/$packageImage';
                                            FullImageViewer.show(
                                              context,
                                              imageUrl,
                                              title: 'Package Image',
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Stack(
                                              children: [
                                                Image.network(
                                                  packageImage.startsWith(
                                                        'http',
                                                      )
                                                      ? packageImage
                                                      : '${ApiEndpoints.baseUrl}/storage/$packageImage',
                                                  height: 150,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return Container(
                                                          height: 150,
                                                          color:
                                                              Colors.grey[200],
                                                          child: const Icon(
                                                            Icons
                                                                .image_not_supported,
                                                          ),
                                                        );
                                                      },
                                                ),
                                                Positioned(
                                                  top: 8,
                                                  right: 8,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black54,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
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
                                      const SizedBox(height: 12),
                                      _buildActionButtons(context, id, status),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
