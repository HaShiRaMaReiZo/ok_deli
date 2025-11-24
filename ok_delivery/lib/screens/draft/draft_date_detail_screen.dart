import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/package_model.dart';
import '../../repositories/package_repository.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../core/utils/date_utils.dart' as myanmar_date;
import '../../widgets/image_preview_screen.dart';
import 'edit_draft_screen.dart';

class DraftDateDetailScreen extends StatefulWidget {
  final DateTime date;
  final List<PackageModel> packages;

  const DraftDateDetailScreen({
    super.key,
    required this.date,
    required this.packages,
  });

  @override
  State<DraftDateDetailScreen> createState() => _DraftDateDetailScreenState();
}

class _DraftDateDetailScreenState extends State<DraftDateDetailScreen> {
  final _packageRepository = PackageRepository(
    ApiClient.create(baseUrl: ApiEndpoints.baseUrl),
  );

  late List<PackageModel> _packages;
  bool _isDeleting = false;
  bool _isSubmitting = false;
  bool _packagesWereSubmitted = false;

  @override
  void initState() {
    super.initState();
    _packages = List.from(widget.packages);
  }

  Future<void> _loadDrafts() async {
    try {
      final drafts = await _packageRepository.getDrafts();
      final filteredDrafts = drafts.where((d) {
        // Use Myanmar timezone for comparison
        final draftDate = myanmar_date.MyanmarDateUtils.getDateKey(d.createdAt);
        final widgetDate = DateTime(
          widget.date.year,
          widget.date.month,
          widget.date.day,
        );
        return draftDate == widgetDate;
      }).toList();

      if (mounted) {
        setState(() {
          _packages = filteredDrafts;
        });

        // If no drafts found for this date and packages were submitted, navigate back
        // This means all packages were submitted successfully
        if (filteredDrafts.isEmpty && _packagesWereSubmitted) {
          // Navigate back to draft list
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        // Only show error if it's not an empty list scenario
        if (!e.toString().contains('No valid draft packages found')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error loading drafts: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          // If no drafts found, navigate back to draft list
          Navigator.of(context).pop(true);
        }
      }
    }
  }

  Future<void> _deleteDraft(int packageId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Draft'),
        content: const Text(
          'Are you sure you want to delete this draft package?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      await _packageRepository.deleteDraft(packageId);

      if (mounted) {
        setState(() {
          _packages.removeWhere((p) => p.id == packageId);
          _isDeleting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Draft deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // If no packages left, go back
        if (_packages.isEmpty) {
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _registerAllPackages() async {
    if (_packages.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Register All Packages'),
        content: Text(
          'Are you sure you want to register all ${_packages.length} package(s)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Register'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final packageIds = _packages.map((p) => p.id).toList();
      final response = await _packageRepository.submitDrafts(packageIds);

      if (mounted) {
        // Mark that packages were submitted before clearing
        _packagesWereSubmitted = true;

        setState(() {
          _isSubmitting = false;
          // Clear packages list immediately since they're no longer drafts
          _packages = [];
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Registration Result'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  response.submittedCount > 0
                      ? '${response.submittedCount} package(s) registered successfully'
                      : '${response.createdCount} package(s) registered successfully',
                ),
                if (response.failedCount > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${response.failedCount} package(s) failed',
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                if (response.errors.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text('Errors:'),
                  ...response.errors.map(
                    (e) => Text(
                      '${e.customerName}: ${e.error}',
                      style: const TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(true); // Go back to draft list
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    // date is already in Myanmar timezone from getDateKey
    final now = myanmar_date.MyanmarDateUtils.getMyanmarNow();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatDateTime(DateTime utcDateTime) {
    return myanmar_date.MyanmarDateUtils.formatDateTime(utcDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBeige,
      appBar: AppBar(
        title: Text(_formatDate(widget.date)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isDeleting || _isSubmitting
          ? const Center(child: CircularProgressIndicator())
          : _packages.isEmpty
          ? const Center(
              child: Text(
                'No packages for this date',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _packages.length,
                    itemBuilder: (context, index) {
                      final package = _packages[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Package Image
                              if (package.packageImage != null)
                                GestureDetector(
                                  onTap: () {
                                    ImagePreviewScreen.show(
                                      context,
                                      package.packageImage!,
                                      title: 'Package Image',
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      package.packageImage!,
                                      width: double.infinity,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                height: 120,
                                                color: Colors.grey[300],
                                                child: const Center(
                                                  child: Icon(Icons.error),
                                                ),
                                              ),
                                    ),
                                  ),
                                ),
                              if (package.packageImage != null)
                                const SizedBox(height: 12),
                              // Customer Name
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    size: 18,
                                    color: AppTheme.darkBlue,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      package.customerName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Customer Phone
                              Row(
                                children: [
                                  const Icon(
                                    Icons.phone,
                                    size: 18,
                                    color: AppTheme.darkBlue,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    package.customerPhone,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Delivery Address
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 18,
                                    color: AppTheme.darkBlue,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      package.deliveryAddress,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Payment Type and Amount
                              Row(
                                children: [
                                  const Icon(
                                    Icons.payment,
                                    size: 18,
                                    color: AppTheme.darkBlue,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    package.paymentType.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${package.amount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.darkBlue,
                                    ),
                                  ),
                                ],
                              ),
                              // Package Description (if exists)
                              if (package.packageDescription != null &&
                                  package.packageDescription!.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.description,
                                      size: 18,
                                      color: AppTheme.darkBlue,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        package.packageDescription!,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 8),
                              // Created At and Action Buttons
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Created: ${_formatDateTime(package.createdAt)}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: AppTheme.darkBlue,
                                      size: 20,
                                    ),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditDraftScreen(package: package),
                                        ),
                                      );

                                      if (result == true) {
                                        // Reload drafts to get updated data
                                        _loadDrafts();
                                      }
                                    },
                                    tooltip: 'Edit',
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    onPressed: () => _deleteDraft(package.id),
                                    tooltip: 'Delete',
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Register All Button
                if (_packages.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSubmitting
                              ? null
                              : _registerAllPackages,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.darkBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Register All Packages',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
