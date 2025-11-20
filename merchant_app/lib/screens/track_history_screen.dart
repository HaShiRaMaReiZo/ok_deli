import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../repositories/package_repository.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/empty_state_widget.dart';

class TrackHistoryScreen extends StatefulWidget {
  const TrackHistoryScreen({super.key, required this.packageId});
  final int packageId;

  @override
  State<TrackHistoryScreen> createState() => _TrackHistoryScreenState();
}

class _TrackHistoryScreenState extends State<TrackHistoryScreen> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _items = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = context.read<PackageRepository>();
      final items = await repo.trackHistory(widget.packageId);
      setState(() => _items = items);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
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

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Status History'), elevation: 0),
      body: _loading
          ? const AppLoadingWidget(message: 'Loading history...')
          : _error != null
          ? AppErrorWidget(
              message: _error!,
              title: 'Error loading history',
              onRetry: _load,
            )
          : _items.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.history,
              title: 'No history available',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length,
              itemBuilder: (context, i) {
                final h = _items[i];
                final isFirst = i == 0;
                final isLast = i == _items.length - 1;
                final status = h['status']?.toString() ?? 'Unknown';

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline
                    Column(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isFirst
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey[300],
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: isFirst
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 60,
                            color: Colors.grey[300],
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // Content
                    Expanded(
                      child: Card(
                        elevation: isFirst ? 3 : 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: isFirst
                            ? Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.05)
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatStatus(status),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isFirst
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(h['created_at']?.toString()),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (h['notes'] != null &&
                                  h['notes'].toString().isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  h['notes'].toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
