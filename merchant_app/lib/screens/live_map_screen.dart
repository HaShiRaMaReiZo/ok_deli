import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../repositories/package_repository.dart';
import '../bloc/websocket/websocket_bloc.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({super.key, required this.packageId});
  final int packageId;

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  final MapController _mapController = MapController();
  Timer? _timer;
  bool _loading = true;
  String? _error;
  LatLng? _currentPosition;
  String? _riderName;
  double _currentZoom = 15.0; // Track current zoom level
  StreamSubscription<WebSocketState>? _wsSubscription;
  bool _isLiveTracking =
      true; // Track if we're doing live tracking or showing last location
  String? _packageStatus; // Track package status

  @override
  void initState() {
    super.initState();
    _fetchOnce();
    // Timer will be started/stopped based on package status
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchOnce());

    // Subscribe to WebSocket for real-time location updates
    // Will be stopped if package is delivered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupWebSocket();
    });
  }

  void _setupWebSocket() async {
    try {
      final wsBloc = context.read<WebSocketBloc>();
      final wsService = wsBloc.service;

      // Connect if not connected
      if (!wsService.isConnected) {
        wsBloc.add(const WebSocketEvent.connect());
        // Wait a bit for connection
        await Future.delayed(const Duration(seconds: 1));
      }

      // Subscribe to package location channel
      wsBloc.add(WebSocketEvent.subscribeToPackageLocation(widget.packageId));

      // Listen to WebSocket BLoC stream for updates
      _wsSubscription = wsBloc.stream.listen((state) {
        state.when(
          disconnected: () {},
          connected: () {},
          subscribedToMerchant: (_) {},
          subscribedToPackageLocation: (_) {},
          error: (_) {},
          packageUpdateReceived: (_) {},
          riderLocationUpdateReceived: (packageId, data) {
            if (packageId == widget.packageId && _isLiveTracking) {
              // Only update location if we're doing live tracking
              try {
                final locationData = jsonDecode(data) as Map<String, dynamic>;
                final lat = _parseCoordinate(locationData['latitude']);
                final lng = _parseCoordinate(locationData['longitude']);
                if (lat != null && lng != null) {
                  _updateLocation(LatLng(lat, lng), locationData);
                }
              } catch (e) {
                // Handle parsing error
                print('Error parsing WebSocket location: $e');
              }
            }
          },
        );
      });

      // Also listen to channel events directly as backup
      final channel = await wsService.subscribeToPackageLocationChannel(
        widget.packageId,
      );
      if (channel != null) {
        // Listen to channel events directly
        channel.onEvent = (dynamic eventData) {
          if (eventData is PusherEvent &&
              eventData.eventName == 'rider.location.updated') {
            try {
              // Only update if we're doing live tracking
              if (_isLiveTracking) {
                final locationData = eventData.data is Map<String, dynamic>
                    ? eventData.data as Map<String, dynamic>
                    : jsonDecode(eventData.data.toString())
                          as Map<String, dynamic>;
                final lat = _parseCoordinate(locationData['latitude']);
                final lng = _parseCoordinate(locationData['longitude']);
                if (lat != null && lng != null) {
                  _updateLocation(LatLng(lat, lng), locationData);
                }
              }
            } catch (e) {
              // Handle parsing error
            }
          }
        };
      }
    } catch (e) {
      // Handle WebSocket setup error
    }
  }

  // Helper function to parse latitude/longitude from string or number
  double? _parseCoordinate(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  // Calculate distance between two coordinates in kilometers using Haversine formula
  double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371; // Earth radius in kilometers
    final double lat1Rad = point1.latitude * (math.pi / 180);
    final double lat2Rad = point2.latitude * (math.pi / 180);
    final double deltaLat =
        (point2.latitude - point1.latitude) * (math.pi / 180);
    final double deltaLng =
        (point2.longitude - point1.longitude) * (math.pi / 180);

    final double a =
        math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(deltaLng / 2) *
            math.sin(deltaLng / 2);
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  void _updateLocation(LatLng position, Map<String, dynamic> data) {
    if (!mounted) return;

    // Update position
    setState(() {
      _currentPosition = position;
      _riderName = data['name']?.toString();
      _loading = false;
      _error = null;
    });

    // Only move camera if this is the first time or location changed significantly
    // Don't reset zoom - preserve user's zoom level
    if (_currentPosition == null) {
      // First time - center on location with default zoom
      _mapController.move(position, _currentZoom);
      _currentZoom = 15;
    } else {
      // Update location but preserve zoom level
      final distance = _calculateDistance(_currentPosition!, position);
      if (distance > 0.1) {
        // Location changed significantly, update camera but keep zoom
        _mapController.move(position, _currentZoom);
      }
    }
  }

  Future<void> _fetchOnce() async {
    try {
      final repo = context.read<PackageRepository>();
      final response = await repo.liveLocation(widget.packageId);
      if (response == null) {
        setState(() {
          _error = 'Location not available';
          _loading = false;
        });
        return;
      }

      // Extract package status and is_live flag
      final packageData = response['package'] as Map<String, dynamic>?;
      final packageStatus = packageData?['status']?.toString();
      final isLive = response['is_live'] as bool? ?? false;

      // Extract rider data
      final riderData = response['rider'] as Map<String, dynamic>?;
      if (riderData == null) {
        setState(() {
          _error = response['message']?.toString() ?? 'No rider data available';
          _loading = false;
        });
        return;
      }

      final lat = _parseCoordinate(riderData['latitude']);
      final lng = _parseCoordinate(riderData['longitude']);
      if (lat == null || lng == null) {
        setState(() {
          _error = 'Invalid location data';
          _loading = false;
        });
        return;
      }
      final pos = LatLng(lat, lng);

      // Update state
      final wasLiveTracking = _isLiveTracking;
      setState(() {
        _currentPosition = pos;
        _riderName = riderData['name']?.toString();
        _loading = false;
        _error = null;
        _isLiveTracking = isLive;
        _packageStatus = packageStatus;
      });

      // If package is delivered or not live, stop tracking
      if (!isLive || packageStatus == 'delivered') {
        _stopLiveTracking();
      } else if (!wasLiveTracking && isLive) {
        // If we just switched to live tracking, restart it
        _startLiveTracking();
      }

      // Only move camera if this is the first time or location changed significantly
      // Don't reset zoom - preserve user's zoom level
      if (_currentPosition == null) {
        // First time - center on location with default zoom
        _mapController.move(pos, 15);
        _currentZoom = 15;
      } else if (isLive) {
        // Only update camera for live tracking, not for last location
        final distance = _calculateDistance(_currentPosition!, pos);
        if (distance > 0.1) {
          // Location changed significantly, update camera but keep zoom
          _mapController.move(pos, _currentZoom);
        }
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _stopLiveTracking() {
    // Stop periodic timer
    _timer?.cancel();
    _timer = null;

    // Unsubscribe from WebSocket
    if (mounted) {
      final wsBloc = context.read<WebSocketBloc>();
      wsBloc.add(
        WebSocketEvent.unsubscribeFromPackageLocation(widget.packageId),
      );
    }
  }

  void _startLiveTracking() {
    // Start periodic timer if not already running
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchOnce());
    }

    // Setup WebSocket if not already set up
    _setupWebSocket();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _wsSubscription?.cancel();
    _mapController.dispose();
    // Unsubscribe from WebSocket when leaving the screen
    if (mounted) {
      final wsBloc = context.read<WebSocketBloc>();
      wsBloc.add(
        WebSocketEvent.unsubscribeFromPackageLocation(widget.packageId),
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initialPosition =
        _currentPosition ?? const LatLng(16.8661, 96.1951); // Yangon, Myanmar

    return Scaffold(
      appBar: AppBar(
        title: Text(_isLiveTracking ? 'Live Location' : 'Last Location'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchOnce,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _loading && _currentPosition == null
          ? const AppLoadingWidget(message: 'Loading location...')
          : _error != null && _currentPosition == null
          ? AppErrorWidget(
              message: _error!,
              title: 'Location Not Available',
              icon: Icons.location_off,
              onRetry: _fetchOnce,
            )
          : Stack(
              children: [
                // Banner showing delivery status
                if (!_isLiveTracking && _packageStatus == 'delivered')
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      color: Colors.green.withOpacity(0.9),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Package Delivered - Showing Last Location',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: initialPosition,
                    initialZoom: _currentZoom,
                    minZoom: 0,
                    maxZoom: 19, // OpenStreetMap tiles support up to zoom 19
                    onMapEvent: (event) {
                      if (event is MapEventMove) {
                        // Track current zoom level from map controller
                        _currentZoom = _mapController.camera.zoom;
                      }
                    },
                  ),
                  children: [
                    // OpenStreetMap tiles - accessible worldwide without VPN
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png?key=2FU1Toy7etAR00Vzt5Ho',
                      subdomains: const ['a', 'b', 'c'],
                      maxZoom: 19,
                      minZoom: 0,
                      userAgentPackageName: 'com.example.merchant_app',
                    ),
                    // Rider location marker
                    if (_currentPosition != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _currentPosition!,
                            width: 40,
                            height: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                // Navigation controls
                Positioned(
                  top: 16,
                  right: 16,
                  child: Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: 'zoom-in',
                        onPressed: _currentZoom >= 19
                            ? null // Disable if at max zoom (19)
                            : () {
                                if (_currentPosition != null) {
                                  // Only zoom in if not at max zoom (19)
                                  if (_currentZoom < 19) {
                                    final newZoom = (_currentZoom + 1).clamp(
                                      0.0,
                                      19.0,
                                    );
                                    _currentZoom = newZoom;
                                    _mapController.move(
                                      _currentPosition!,
                                      newZoom,
                                    );
                                  }
                                }
                              },
                        backgroundColor: _currentZoom >= 19
                            ? Colors.grey[300]
                            : null,
                        child: Icon(
                          Icons.add,
                          color: _currentZoom >= 19 ? Colors.grey[600] : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: 'zoom-out',
                        onPressed: _currentZoom <= 0
                            ? null // Disable if at min zoom
                            : () {
                                if (_currentPosition != null) {
                                  // Only zoom out if not at min zoom (0)
                                  if (_currentZoom > 0) {
                                    final newZoom = (_currentZoom - 1).clamp(
                                      0.0,
                                      18.0,
                                    );
                                    _currentZoom = newZoom;
                                    _mapController.move(
                                      _currentPosition!,
                                      newZoom,
                                    );
                                  }
                                }
                              },
                        backgroundColor: _currentZoom <= 0
                            ? Colors.grey[300]
                            : null,
                        child: Icon(
                          Icons.remove,
                          color: _currentZoom <= 0 ? Colors.grey[600] : null,
                        ),
                      ),
                    ],
                  ),
                ),
                // Rider name label overlay (positioned at bottom)
                if (_currentPosition != null && _riderName != null)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _riderName!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (_error != null && _currentPosition != null)
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Card(
                      color: Colors.orange[50],
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber,
                              color: Colors.orange[700],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _error!,
                                style: TextStyle(color: Colors.orange[900]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                // Attribution
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '© OpenStreetMap contributors',
                      style: TextStyle(fontSize: 10, color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
