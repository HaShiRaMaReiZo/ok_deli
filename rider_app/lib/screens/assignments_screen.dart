import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../bloc/assignments/assignments_bloc.dart';
import '../bloc/delivery/delivery_bloc.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Assignments')),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<AssignmentsBloc, AssignmentsState>(
              builder: (context, state) {
                return state.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  failure: (m) => Center(child: Text(m)),
                  loaded: (assignments) => ListView.separated(
                    itemCount: assignments.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final a = assignments[i];
                      final id =
                          a['id'] as int? ?? a['package_id'] as int? ?? 0;
                      return ListTile(
                        title: Text('Package #$id'),
                        subtitle: Text('Status: ${a['status']}'),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            final dBloc = context.read<DeliveryBloc>();
                            if (value == 'start') {
                              dBloc.add(
                                DeliveryEvent.startDelivery(packageId: id),
                              );
                            } else if (value == 'picked_up') {
                              dBloc.add(
                                DeliveryEvent.updateStatus(
                                  packageId: id,
                                  status: 'picked_up',
                                ),
                              );
                            } else if (value == 'on_the_way') {
                              dBloc.add(
                                DeliveryEvent.updateStatus(
                                  packageId: id,
                                  status: 'on_the_way',
                                ),
                              );
                            } else if (value == 'delivered') {
                              dBloc.add(
                                DeliveryEvent.updateStatus(
                                  packageId: id,
                                  status: 'delivered',
                                ),
                              );
                            } else if (value == 'contact_failed') {
                              dBloc.add(
                                DeliveryEvent.contactCustomer(
                                  packageId: id,
                                  success: false,
                                ),
                              );
                            } else if (value == 'collect_cod') {
                              _showCodDialog(context, id, dBloc);
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: 'start',
                              child: Text('Start Delivery'),
                            ),
                            PopupMenuItem(
                              value: 'picked_up',
                              child: Text('Picked Up'),
                            ),
                            PopupMenuItem(
                              value: 'on_the_way',
                              child: Text('On The Way'),
                            ),
                            PopupMenuItem(
                              value: 'delivered',
                              child: Text('Delivered'),
                            ),
                            PopupMenuItem(
                              value: 'contact_failed',
                              child: Text('Contact Failed'),
                            ),
                            PopupMenuItem(
                              value: 'collect_cod',
                              child: Text('Collect COD'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          BlocBuilder<DeliveryBloc, DeliveryState>(
            builder: (context, state) {
              return state.maybeWhen(
                loading: () => const LinearProgressIndicator(),
                success: (m) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(m, style: const TextStyle(color: Colors.green)),
                ),
                failure: (m) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(m, style: const TextStyle(color: Colors.red)),
                ),
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<AssignmentsBloc>().add(
          const AssignmentsEvent.fetchRequested(),
        ),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _showCodDialog(BuildContext context, int packageId, DeliveryBloc bloc) {
    final amountController = TextEditingController();
    File? proofImage;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Collect COD'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  final picker = ImagePicker();
                  final image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    setState(() => proofImage = File(image.path));
                  }
                },
                icon: const Icon(Icons.image),
                label: Text(proofImage == null ? 'Add Proof' : 'Proof Added'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text.trim());
                if (amount != null && amount > 0) {
                  bloc.add(
                    DeliveryEvent.collectCod(
                      packageId: packageId,
                      amount: amount,
                      imagePath: proofImage?.path,
                    ),
                  );
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Collect'),
            ),
          ],
        ),
      ),
    );
  }
}
