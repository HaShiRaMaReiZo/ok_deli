import 'package:flutter/material.dart';
import '../models/package.dart';
import 'track_history_screen.dart';
import 'live_map_screen.dart';

class PackageDetailsScreen extends StatelessWidget {
  const PackageDetailsScreen({super.key, required this.package});

  final Package package;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Package ${package.trackingCode}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${package.status}'),
            Text('Customer: ${package.customerName} (${package.customerPhone})'),
            Text('Address: ${package.deliveryAddress}'),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => TrackHistoryScreen(packageId: package.id)),
                    );
                  },
                  child: const Text('Track History'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: package.status == 'on_the_way'
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => LiveMapScreen(packageId: package.id)),
                          );
                        }
                      : null,
                  child: const Text('Live Location'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
