import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../repositories/package_repository.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({super.key, required this.packageId});
  final int packageId;

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  GoogleMapController? _mapController;
  Marker? _riderMarker;
  Timer? _timer;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchOnce();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchOnce());
  }

  Future<void> _fetchOnce() async {
    try {
      final repo = context.read<PackageRepository>();
      final data = await repo.liveLocation(widget.packageId);
      if (data == null) {
        setState(() {
          _error = 'Location not available';
          _loading = false;
        });
        return;
      }
      final lat = (data['latitude'] as num?)?.toDouble();
      final lng = (data['longitude'] as num?)?.toDouble();
      if (lat == null || lng == null) return;
      final pos = LatLng(lat, lng);
      setState(() {
        _riderMarker = Marker(
          markerId: const MarkerId('rider'),
          position: pos,
          infoWindow: InfoWindow(title: data['name']?.toString() ?? 'Rider'),
        );
        _loading = false;
      });
      _mapController?.animateCamera(CameraUpdate.newLatLng(pos));
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>{if (_riderMarker != null) _riderMarker!};
    return Scaffold(
      appBar: AppBar(title: const Text('Live Location')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(0, 0),
                    zoom: 12,
                  ),
                  markers: markers,
                  onMapCreated: (c) => _mapController = c,
                ),
    );
  }
}
