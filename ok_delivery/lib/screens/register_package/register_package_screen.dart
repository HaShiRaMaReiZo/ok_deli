import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../core/theme/app_theme.dart';
import '../../models/package_model.dart';
import '../../repositories/package_repository.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../widgets/image_preview_screen.dart';

// Helper class to store package with its image and draft ID
class PackageWithImage {
  final CreatePackageModel package;
  final File? imageFile;
  int? draftId; // Store draft ID after saving to API

  PackageWithImage({required this.package, this.imageFile, this.draftId});
}

class RegisterPackageScreen extends StatefulWidget {
  const RegisterPackageScreen({super.key});

  @override
  State<RegisterPackageScreen> createState() => _RegisterPackageScreenState();
}

class _RegisterPackageScreenState extends State<RegisterPackageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _packageRepository = PackageRepository(
    ApiClient.create(baseUrl: ApiEndpoints.baseUrl),
  );

  // Current package form fields
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _deliveryAddressController = TextEditingController();
  final _amountController = TextEditingController();
  final _packageDescriptionController = TextEditingController();

  String _paymentType = 'prepaid';
  File? _selectedImage;
  final List<PackageWithImage> _packageList = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _deliveryAddressController.dispose();
    _amountController.dispose();
    _packageDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      // Check camera permission status first (this doesn't show a dialog)
      final cameraStatus = await Permission.camera.status;

      // Only request permission if not already granted
      // This will show the system permission dialog when user clicks the button
      if (!cameraStatus.isGranted) {
        final result = await Permission.camera.request();

        if (!result.isGranted) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Camera permission is required to take photos. Please grant permission in settings.',
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
          return;
        }
      }

      // Open camera to take photo
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error taking photo: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _clearForm() {
    _customerNameController.clear();
    _customerPhoneController.clear();
    _deliveryAddressController.clear();
    _amountController.clear();
    _packageDescriptionController.clear();
    _paymentType = 'prepaid';
    setState(() {
      _selectedImage = null;
    });
  }

  Future<String?> _encodeImageToBase64(File? imageFile) async {
    if (imageFile == null) return null;
    try {
      final bytes = await imageFile.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      return null;
    }
  }

  Future<void> _addToPackageList() async {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text.trim());
      if (amount == null || amount < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid amount')),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      try {
        final base64Image = await _encodeImageToBase64(_selectedImage);

        final package = CreatePackageModel(
          customerName: _customerNameController.text.trim(),
          customerPhone: _customerPhoneController.text.trim(),
          deliveryAddress: _deliveryAddressController.text.trim(),
          paymentType: _paymentType,
          amount: amount,
          packageImage: base64Image,
          packageDescription: _packageDescriptionController.text.trim().isEmpty
              ? null
              : _packageDescriptionController.text.trim(),
        );

        // Save to draft API
        final response = await _packageRepository.saveDraft([package]);

        if (response.packages.isNotEmpty) {
          final savedPackage = response.packages.first;
          setState(() {
            _packageList.add(
              PackageWithImage(
                package: package,
                imageFile: _selectedImage,
                draftId: savedPackage.id,
              ),
            );
          });

          _clearForm();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Package saved to draft (${_packageList.length} total)',
                ),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to save package to draft'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  Future<void> _submitPackages() async {
    if (_packageList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one package')),
      );
      return;
    }

    // Get all draft IDs
    final draftIds = _packageList
        .where((item) => item.draftId != null)
        .map((item) => item.draftId!)
        .toList();

    if (draftIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No valid draft packages to submit'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Submit drafts to system
      final response = await _packageRepository.submitDrafts(draftIds);

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Submission Result'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${response.submittedCount > 0 ? response.submittedCount : response.createdCount} package(s) submitted successfully',
                ),
                if (response.failedCount > 0)
                  Text(
                    '${response.failedCount} package(s) failed',
                    style: const TextStyle(color: Colors.red),
                  ),
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
                  Navigator.of(context).pop();
                  setState(() {
                    _packageList.clear();
                    _clearForm();
                  });
                  Navigator.of(context).pop(); // Go back to home
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _removeFromPackageList(int index) {
    setState(() {
      _packageList.removeAt(index);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Package removed from list')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBeige,
      appBar: AppBar(title: const Text('Register Package')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Package List Summary
            if (_packageList.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Package List (${_packageList.length})',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitPackages,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.darkBlue,
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text('Submit All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(_packageList.length, (index) {
                      final item = _packageList[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: item.imageFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    item.imageFile!,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(Icons.inventory_2),
                          title: Text(item.package.customerName),
                          subtitle: Text(
                            '${item.package.deliveryAddress} - ${item.package.paymentType.toUpperCase()} - ${item.package.amount.toStringAsFixed(2)}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeFromPackageList(index),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            if (_packageList.isNotEmpty) const SizedBox(height: 16),

            // Package Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Customer Name
                  TextFormField(
                    controller: _customerNameController,
                    decoration: const InputDecoration(
                      labelText: 'Customer Name *',
                      hintText: 'Enter customer name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter customer name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Customer Phone
                  TextFormField(
                    controller: _customerPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Customer Phone *',
                      hintText: 'Enter phone number',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Delivery Address
                  TextFormField(
                    controller: _deliveryAddressController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Delivery Address *',
                      hintText: 'Enter delivery address',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter delivery address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Payment Type
                  DropdownButtonFormField<String>(
                    initialValue: _paymentType,
                    decoration: const InputDecoration(
                      labelText: 'Payment Type *',
                      prefixIcon: Icon(Icons.payment),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'prepaid',
                        child: Text('Prepaid'),
                      ),
                      DropdownMenuItem(value: 'cod', child: Text('COD')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _paymentType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Amount
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Amount *',
                      hintText: 'Enter amount',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter amount';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount < 0) {
                        return 'Please enter a valid amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Package Description (Optional)
                  TextFormField(
                    controller: _packageDescriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Package Description (Optional)',
                      hintText: 'Enter package description',
                      prefixIcon: Icon(Icons.description),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Package Image
                  if (_selectedImage != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              ImagePreviewScreen.showFile(
                                context,
                                _selectedImage!,
                                title: 'Package Image Preview',
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _selectedImage!,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedImage = null;
                                });
                              },
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    OutlinedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Take Package Photo (Optional)'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Add to List Button
                  ElevatedButton(
                    onPressed: _addToPackageList,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Add to List'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
