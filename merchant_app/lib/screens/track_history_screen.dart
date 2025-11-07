import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/package_repository.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Status History')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView.separated(
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final h = _items[i];
                    return ListTile(
                      title: Text(h['status'].toString()),
                      subtitle: Text(h['created_at']?.toString() ?? ''),
                    );
                  },
                ),
    );
  }
}
