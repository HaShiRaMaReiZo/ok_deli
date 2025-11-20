import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../repositories/package_repository.dart';

class BulkCreatePackageScreen extends StatefulWidget {
  const BulkCreatePackageScreen({super.key});

  @override
  State<BulkCreatePackageScreen> createState() =>
      _BulkCreatePackageScreenState();
}

class _BulkCreatePackageScreenState extends State<BulkCreatePackageScreen> {
  final List<Map<String, dynamic>> _packages =
      []; // Changed to dynamic to store File?
  final List<String> _paymentTypes = ['cod', 'prepaid'];
  final ImagePicker _imagePicker = ImagePicker();
  bool _loading = false;
  String? _error;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    // Start with 1 empty row
    _addPackageRow();
  }

  void _addPackageRow({int count = 1}) {
    setState(() {
      for (int i = 0; i < count; i++) {
        _packages.add({
          'customer_name': TextEditingController(),
          'customer_phone': TextEditingController(),
          'customer_email': TextEditingController(),
          'delivery_address': TextEditingController(),
          'amount': TextEditingController(),
          'payment_type': TextEditingController(text: 'cod'),
          'package_description': TextEditingController(),
          'package_image': null as File?, // Store image file
        });
      }
    });
  }

  Future<void> _showAddRowsDialog() async {
    final countController = TextEditingController(text: '1');
    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Rows'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('How many rows would you like to add?'),
            const SizedBox(height: 16),
            TextField(
              controller: countController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Number of rows',
                border: OutlineInputBorder(),
                hintText: 'Enter number (1-50)',
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final count = int.tryParse(countController.text) ?? 1;
              if (count > 0 && count <= 50) {
                Navigator.of(context).pop(count);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a number between 1 and 50'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result != null && result > 0) {
      _addPackageRow(count: result);
    }
  }

  void _removePackageRow(int index) {
    // Don't allow removing the last row - keep at least one row
    if (_packages.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least one row must remain'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    setState(() {
      _packages.removeAt(index);
    });
  }

  void _duplicateRow(int index) {
    setState(() {
      final original = _packages[index];
      _packages.add({
        'customer_name': TextEditingController(
          text: original['customer_name']!.text,
        ),
        'customer_phone': TextEditingController(
          text: original['customer_phone']!.text,
        ),
        'customer_email': TextEditingController(
          text: original['customer_email']!.text,
        ),
        'delivery_address': TextEditingController(
          text: original['delivery_address']!.text,
        ),
        'amount': TextEditingController(text: original['amount']!.text),
        'payment_type': TextEditingController(
          text: original['payment_type']!.text,
        ),
        'package_description': TextEditingController(
          text: original['package_description']!.text,
        ),
        'package_image':
            original['package_image'] as File?, // Copy image reference
      });
    });
  }

  void _clearAll() {
    setState(() {
      for (var package in _packages) {
        for (var entry in package.entries) {
          if (entry.key == 'payment_type') {
            // Reset payment type to default 'cod'
            (entry.value as TextEditingController).text = 'cod';
          } else if (entry.key == 'package_image') {
            package['package_image'] = null;
          } else if (entry.value is TextEditingController) {
            (entry.value as TextEditingController).clear();
          }
        }
      }
    });
  }

  Future<void> _pickImage(int index) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera, // Only camera, no gallery
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image != null) {
        setState(() {
          _packages[index]['package_image'] = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error taking photo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _packages[index]['package_image'] = null;
    });
  }

  void _showFullScreenImage(File imageFile) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.file(imageFile, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black54,
                  shape: const CircleBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitPackages() async {
    setState(() {
      _loading = true;
      _error = null;
      _successMessage = null;
    });

    try {
      // Filter out empty rows (rows where customer_name and customer_phone are empty)
      final validPackages = <Map<String, dynamic>>[];

      for (var package in _packages) {
        final customerName = package['customer_name']!.text.trim();
        final customerPhone = package['customer_phone']!.text.trim();
        final deliveryAddress = package['delivery_address']!.text.trim();

        // Skip empty rows
        if (customerName.isEmpty &&
            customerPhone.isEmpty &&
            deliveryAddress.isEmpty) {
          continue;
        }

        // Validate required fields
        if (customerName.isEmpty) {
          throw Exception('Customer name is required for all packages');
        }
        if (customerPhone.isEmpty) {
          throw Exception('Customer phone is required for all packages');
        }
        if (deliveryAddress.isEmpty) {
          throw Exception('Delivery address is required for all packages');
        }

        final amount = double.tryParse(package['amount']!.text.trim()) ?? 0.0;
        if (amount < 0) {
          throw Exception('Amount must be 0 or greater');
        }

        // Convert image file to base64 if present
        final imageFile = package['package_image'] as File?;
        String? base64Image;
        if (imageFile != null) {
          final imageBytes = await imageFile.readAsBytes();
          base64Image = base64Encode(imageBytes);
        }

        validPackages.add({
          'customer_name': customerName,
          'customer_phone': customerPhone,
          'customer_email': package['customer_email']!.text.trim().isEmpty
              ? null
              : package['customer_email']!.text.trim(),
          'delivery_address': deliveryAddress,
          'payment_type': package['payment_type']!.text.trim(),
          'amount': amount,
          'package_description':
              package['package_description']!.text.trim().isEmpty
              ? null
              : package['package_description']!.text.trim(),
          'package_image': base64Image, // Add base64 image
        });
      }

      if (validPackages.isEmpty) {
        throw Exception('Please fill in at least one package');
      }

      final repo = context.read<PackageRepository>();
      final result = await repo.bulkCreate(validPackages);

      if (mounted) {
        final createdCount = result['created_count'] as int? ?? 0;
        final failedCount = result['failed_count'] as int? ?? 0;

        setState(() {
          _loading = false;
          _successMessage = '$createdCount package(s) created successfully';
          if (failedCount > 0) {
            _error = '$failedCount package(s) failed to create';
          }
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_successMessage!),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );

        // Navigate back after a short delay
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  @override
  void dispose() {
    for (var package in _packages) {
      for (var entry in package.entries) {
        if (entry.value is TextEditingController) {
          (entry.value as TextEditingController).dispose();
        }
        // File objects don't need disposal
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulk Create Packages'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddRowsDialog,
            tooltip: 'Add Rows',
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearAll,
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: Column(
        children: [
          // Info banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.blue[50],
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Fill in package details. Empty rows will be skipped. Tap + to add more rows.',
                    style: TextStyle(color: Colors.blue[900], fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          // Error/Success messages
          if (_error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.red[50],
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _error!,
                      style: TextStyle(color: Colors.red[900]),
                    ),
                  ),
                ],
              ),
            ),

          if (_successMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.green[50],
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.green[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _successMessage!,
                      style: TextStyle(color: Colors.green[900]),
                    ),
                  ),
                ],
              ),
            ),

          // Package list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _packages.length,
              itemBuilder: (context, index) {
                final package = _packages[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row header with actions
                        Row(
                          children: [
                            Text(
                              'Package ${index + 1}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 20),
                              onPressed: () => _duplicateRow(index),
                              tooltip: 'Duplicate',
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.red,
                              ),
                              onPressed: () => _removePackageRow(index),
                              tooltip: 'Remove',
                            ),
                          ],
                        ),
                        const Divider(),

                        // Customer Name
                        TextFormField(
                          controller: package['customer_name'],
                          decoration: const InputDecoration(
                            labelText: 'Customer Name *',
                            border: OutlineInputBorder(),
                          ),
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: 12),

                        // Customer Phone
                        TextFormField(
                          controller: package['customer_phone'],
                          decoration: const InputDecoration(
                            labelText: 'Customer Phone *',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 12),

                        // Customer Email
                        TextFormField(
                          controller: package['customer_email'],
                          decoration: const InputDecoration(
                            labelText: 'Customer Email (Optional)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),

                        // Delivery Address
                        TextFormField(
                          controller: package['delivery_address'],
                          decoration: const InputDecoration(
                            labelText: 'Delivery Address *',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: 12),

                        // Payment Type and Amount
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<String>(
                                value:
                                    _paymentTypes.contains(
                                      package['payment_type']!.text,
                                    )
                                    ? package['payment_type']!.text
                                    : 'cod', // Fallback to 'cod' if value is invalid
                                decoration: const InputDecoration(
                                  labelText: 'Payment Type *',
                                  border: OutlineInputBorder(),
                                ),
                                items: _paymentTypes.map((type) {
                                  return DropdownMenuItem(
                                    value: type,
                                    child: Text(type.toUpperCase()),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      package['payment_type']!.text = value;
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: package['amount'],
                                decoration: const InputDecoration(
                                  labelText: 'Amount *',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Package Description
                        TextFormField(
                          controller: package['package_description'],
                          decoration: const InputDecoration(
                            labelText: 'Package Description (Optional)',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),

                        // Image Picker
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Package Image (Optional)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                if (package['package_image'] != null)
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: () => _showFullScreenImage(
                                            package['package_image'] as File,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Image.file(
                                              package['package_image'] as File,
                                              height: 100,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Full screen preview button
                                              GestureDetector(
                                                onTap: () =>
                                                    _showFullScreenImage(
                                                      package['package_image']
                                                          as File,
                                                    ),
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    4,
                                                  ),
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Colors.black54,
                                                        shape: BoxShape.circle,
                                                      ),
                                                  child: const Icon(
                                                    Icons.fullscreen,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              // Remove button
                                              GestureDetector(
                                                onTap: () =>
                                                    _removeImage(index),
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    4,
                                                  ),
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Colors.red,
                                                        shape: BoxShape.circle,
                                                      ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => _pickImage(index),
                                      icon: const Icon(Icons.camera_alt),
                                      label: const Text('Take Photo'),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
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

          // Submit button
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
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _loading ? null : _submitPackages,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: _loading
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
                        'Create Packages',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
