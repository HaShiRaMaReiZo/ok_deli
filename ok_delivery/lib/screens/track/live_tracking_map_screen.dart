import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_theme.dart';
import '../../models/package_model.dart';
import '../../repositories/package_repository.dart';
import '../../core/api/api_client.dart';
import '../../core/api/api_endpoints.dart';
import '../../core/utils/date_utils.dart' as myanmar_date;

class LiveTrackingMapScreen extends StatefulWidget {
  final PackageModel package;

  const LiveTrackingMapScreen({super.key, required this.package});

  @override
  State<LiveTrackingMapScreen> createState() => _LiveTrackingMapScreenState();
}

class _LiveTrackingMapScreenState extends State<LiveTrackingMapScreen> {
  final _packageRepository = PackageRepository(
    ApiClient.create(baseUrl: ApiEndpoints.baseUrl),
  );

  final MapController _mapController = MapController();
  Timer? _locationTimer;
  bool _isLoading = true;
  String? _error;
  bool _isLive = false;
  bool _isDelivered = false;

  // Rider location
  double? _riderLatitude;
  double? _riderLongitude;
  String? _riderName;
  DateTime? _lastUpdate;
  bool _mapReady = false;

  @override
  void initState() {
    super.initState();
    _loadLocation();
    _startPolling();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _loadLocation() async {
    try {
      final response = await _packageRepository.getLiveLocation(
        widget.package.id,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLive = response.isLive;
          // Check status from response, not just initial package status
          _isDelivered = response.package.status == 'delivered';

          if (response.rider != null) {
            _riderLatitude = response.rider!.latitude;
            _riderLongitude = response.rider!.longitude;
            _riderName = response.rider!.name;
            _lastUpdate = response.rider!.lastUpdate;

            // Center map on rider location (only if map is ready)
            if (_riderLatitude != null &&
                _riderLongitude != null &&
                _mapReady) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                try {
                  _mapController.move(
                    LatLng(_riderLatitude!, _riderLongitude!),
                    15.0,
                  );
                } catch (e) {
                  debugPrint('Error moving map: $e');
                }
              });
            }
          } else {
            _error = response.message ?? 'No location data available';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  void _startPolling() {
    // Only poll if package is on_the_way
    if (widget.package.status != 'on_the_way') {
      return;
    }

    _locationTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      // Stop polling if package is delivered
      if (_isDelivered) {
        timer.cancel();
        return;
      }

      try {
        final response = await _packageRepository.getLiveLocation(
          widget.package.id,
        );

        if (mounted) {
          setState(() {
            _isLive = response.isLive;
            // Check status from response, not just initial package status
            _isDelivered = response.package.status == 'delivered';

            if (response.rider != null) {
              _riderLatitude = response.rider!.latitude;
              _riderLongitude = response.rider!.longitude;
              _riderName = response.rider!.name;
              _lastUpdate = response.rider!.lastUpdate;

              // Update map center if location changed significantly (only if map is ready)
              if (_riderLatitude != null &&
                  _riderLongitude != null &&
                  _mapReady) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  try {
                    _mapController.move(
                      LatLng(_riderLatitude!, _riderLongitude!),
                      _mapController.camera.zoom,
                    );
                  } catch (e) {
                    debugPrint('Error updating map center: $e');
                  }
                });
              }
            }

            // Stop polling if package is no longer on_the_way or is delivered
            if (!_isLive || _isDelivered) {
              timer.cancel();
            }
          });
        }
      } catch (e) {
        // Log error but continue polling
        if (mounted) {
          debugPrint('Error polling location: $e');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBeige,
      appBar: AppBar(
        title: Text('Tracking: ${widget.package.trackingCode ?? 'N/A'}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: $_error',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                        _error = null;
                      });
                      _loadLocation();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _riderLatitude == null || _riderLongitude == null
          ? const Center(
              child: Text(
                'No location data available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Stack(
              children: [
                // Map
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: LatLng(_riderLatitude!, _riderLongitude!),
                    initialZoom: 15.0,
                    minZoom: 10.0,
                    maxZoom: 18.0,
                    onMapReady: () {
                      setState(() {
                        _mapReady = true;
                      });
                      // Center map on rider location after map is ready
                      if (_riderLatitude != null && _riderLongitude != null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          try {
                            _mapController.move(
                              LatLng(_riderLatitude!, _riderLongitude!),
                              15.0,
                            );
                          } catch (e) {
                            debugPrint('Error centering map: $e');
                          }
                        });
                      }
                    },
                  ),
                  children: [
                    // OpenStreetMap tiles
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.okdelivery.app',
                      maxZoom: 19,
                    ),
                    // Markers
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(_riderLatitude!, _riderLongitude!),
                          width: 30,
                          height: 30,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _isDelivered
                                  ? Colors.red
                                  : AppTheme.darkBlue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Icon(
                              _isDelivered
                                  ? Icons.location_on
                                  : Icons.navigation,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Package Info Overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Customer Name
                          Text(
                            widget.package.customerName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Tracking Code
                          if (widget.package.trackingCode != null)
                            Row(
                              children: [
                                const Icon(
                                  Icons.qr_code,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  widget.package.trackingCode!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
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
                                size: 16,
                                color: AppTheme.darkBlue,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  widget.package.deliveryAddress,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Rider Name
                          if (_riderName != null)
                            Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Rider: $_riderName',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          // Last Update
                          if (_lastUpdate != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  _isLive
                                      ? Icons.circle
                                      : Icons.circle_outlined,
                                  size: 12,
                                  color: _isLive ? Colors.green : Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _isDelivered
                                      ? 'Delivered at: ${myanmar_date.MyanmarDateUtils.formatDateTime(_lastUpdate!)}'
                                      : 'Last update: ${myanmar_date.MyanmarDateUtils.formatDateTime(_lastUpdate!)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _isLive ? Colors.green : Colors.grey,
                                    fontWeight: _isLive
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
