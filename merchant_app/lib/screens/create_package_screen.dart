import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../repositories/package_repository.dart';

class CreatePackageScreen extends StatefulWidget {
  const CreatePackageScreen({super.key});

  @override
  State<CreatePackageScreen> createState() => _CreatePackageScreenState();
}

class _CreatePackageScreenState extends State<CreatePackageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerName = TextEditingController();
  final _customerPhone = TextEditingController();
  final _customerEmail = TextEditingController();
  final _deliveryAddress = TextEditingController();
  final _amount = TextEditingController();
  String _paymentType = 'cod';
  bool _loading = false;
  String? _error;
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Package')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              TextFormField(
                controller: _customerName,
                decoration: const InputDecoration(labelText: 'Customer Name'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _customerPhone,
                decoration: const InputDecoration(labelText: 'Customer Phone'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _customerEmail,
                decoration: const InputDecoration(
                  labelText: 'Customer Email (optional)',
                ),
              ),
              TextFormField(
                controller: _deliveryAddress,
                decoration: const InputDecoration(
                  labelText: 'Delivery Address',
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              DropdownButtonFormField<String>(
                value: _paymentType,
                items: const [
                  DropdownMenuItem(value: 'cod', child: Text('COD')),
                  DropdownMenuItem(value: 'prepaid', child: Text('Prepaid')),
                ],
                onChanged: (v) => setState(() => _paymentType = v ?? 'cod'),
                decoration: const InputDecoration(labelText: 'Payment Type'),
              ),
              TextFormField(
                controller: _amount,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  final picker = ImagePicker();
                  final image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    setState(() => _selectedImage = File(image.path));
                  }
                },
                icon: const Icon(Icons.image),
                label: Text(
                  _selectedImage == null
                      ? 'Pick Package Image'
                      : 'Image Selected',
                ),
              ),
              if (_selectedImage != null)
                Image.file(_selectedImage!, height: 100, fit: BoxFit.cover),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;
                        setState(() {
                          _loading = true;
                          _error = null;
                        });
                        try {
                          final repo = context.read<PackageRepository>();
                          await repo.create({
                            'customer_name': _customerName.text.trim(),
                            'customer_phone': _customerPhone.text.trim(),
                            'customer_email': _customerEmail.text.trim().isEmpty
                                ? null
                                : _customerEmail.text.trim(),
                            'delivery_address': _deliveryAddress.text.trim(),
                            'payment_type': _paymentType,
                            'amount': double.tryParse(_amount.text.trim()) ?? 0,
                          }, imagePath: _selectedImage?.path);
                          if (mounted) Navigator.of(context).pop(true);
                        } catch (e) {
                          setState(() => _error = e.toString());
                        } finally {
                          if (mounted) setState(() => _loading = false);
                        }
                      },
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
