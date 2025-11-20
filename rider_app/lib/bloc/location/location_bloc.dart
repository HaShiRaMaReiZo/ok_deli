import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location_package;
import 'package:permission_handler/permission_handler.dart';
import '../../services/location_service.dart';

part 'location_event.dart';
part 'location_state.dart';
part 'location_bloc.freezed.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc({required this.service}) : super(const LocationState.idle()) {
    on<_Start>((event, emit) async {
      debugPrint(
        'LocationBloc: Start event received, packageId: ${event.packageId}',
      );

      _timer?.cancel();
      _streamSubscription?.cancel();
      _backgroundStreamSubscription?.cancel();

      // Request location permissions
      debugPrint('LocationBloc: Checking if location service is enabled...');
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      debugPrint('LocationBloc: Location service enabled: $serviceEnabled');
      if (!serviceEnabled) {
        debugPrint(
          'LocationBloc: Location service is disabled, attempting to open settings...',
        );
        // Try to open location settings so user can enable it
        try {
          await Geolocator.openLocationSettings();
          debugPrint('LocationBloc: Location settings opened');
        } catch (e) {
          debugPrint('LocationBloc: Failed to open location settings: $e');
        }
        emit(
          LocationState.error(
            'Location services are disabled. Please enable location/GPS in your device settings.',
          ),
        );
        return;
      }

      // Check and request foreground location permission
      debugPrint('LocationBloc: Checking foreground location permission...');
      LocationPermission permission = await Geolocator.checkPermission();
      debugPrint('LocationBloc: Current permission status: $permission');

      if (permission == LocationPermission.denied) {
        debugPrint('LocationBloc: Permission denied, requesting...');
        permission = await Geolocator.requestPermission();
        debugPrint('LocationBloc: Permission after request: $permission');

        if (permission == LocationPermission.denied) {
          debugPrint('LocationBloc: Permission still denied, emitting error');
          emit(LocationState.error('Location permissions are denied.'));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint(
          'LocationBloc: Permission permanently denied, emitting error',
        );
        emit(
          LocationState.error(
            'Location permissions are permanently denied. Please enable in settings.',
          ),
        );
        return;
      }

      debugPrint('LocationBloc: Foreground permission granted, continuing...');

      // Request background location permission (Android 10+)
      // This is OPTIONAL for foreground tracking, but REQUIRED for background tracking
      // Don't wait for this - just check and continue
      debugPrint('LocationBloc: Checking background location permission...');
      try {
        PermissionStatus backgroundPermission =
            await Permission.locationAlways.status;
        debugPrint(
          'LocationBloc: Background permission status: $backgroundPermission',
        );

        if (backgroundPermission.isDenied) {
          debugPrint(
            'LocationBloc: Background permission denied, requesting (non-blocking)...',
          );
          // Request but don't wait - start tracking immediately
          Permission.locationAlways.request().then((status) {
            debugPrint(
              'LocationBloc: Background permission request result: $status',
            );
          });
        }

        // Don't block tracking if background permission is denied
        // Foreground tracking will still work
        if (backgroundPermission.isPermanentlyDenied) {
          debugPrint(
            'WARNING: Background location permission permanently denied. Foreground tracking will still work.',
          );
        } else if (backgroundPermission.isDenied) {
          debugPrint(
            'WARNING: Background location permission not granted. Location tracking may stop when app is closed.',
          );
        } else {
          debugPrint('LocationBloc: Background permission granted!');
        }
      } catch (e) {
        debugPrint(
          'LocationBloc: Error checking background permission: $e (continuing anyway)',
        );
      }

      debugPrint(
        'LocationBloc: Emitting active state, starting location tracking...',
      );
      emit(const LocationState.active());
      _currentPackageId = event.packageId;

      debugPrint('LocationBloc: Initializing background location service...');
      // Initialize background location service
      _backgroundLocation ??= location_package.Location();

      debugPrint('LocationBloc: Configuring background location settings...');
      // Configure background location settings for better battery efficiency
      try {
        await _backgroundLocation?.changeSettings(
          accuracy: location_package.LocationAccuracy.high,
          interval: 5000, // Update every 5 seconds
          distanceFilter: 10, // Or every 10 meters (whichever comes first)
        );
        debugPrint('LocationBloc: Background location settings configured');
      } catch (e) {
        debugPrint('LocationBloc: Error configuring background settings: $e');
      }

      // Enable background mode for continuous tracking
      // IMPORTANT: This allows location tracking when app is in background,
      // but when app is COMPLETELY CLOSED (killed), Dart code won't run.
      // The native service continues tracking, but API calls may not execute.
      debugPrint('LocationBloc: Enabling background mode...');
      try {
        await _backgroundLocation?.enableBackgroundMode(enable: true);
        debugPrint('LocationBloc: Background mode enabled');
      } catch (e) {
        debugPrint('LocationBloc: Error enabling background mode: $e');
      }

      // Start background location tracking
      // Works when: App is open, App is minimized (background)
      // Limited when: App is completely closed (killed) - native tracking continues but API calls may not work
      debugPrint('LocationBloc: Starting background location stream...');
      _backgroundStreamSubscription = _backgroundLocation?.onLocationChanged.listen(
        (location_package.LocationData locationData) {
          if (locationData.latitude != null && locationData.longitude != null) {
            // Send location update to server
            // Note: This works in background, but may not work when app is completely closed
            service
                .update(
                  latitude: locationData.latitude!,
                  longitude: locationData.longitude!,
                  packageId: _currentPackageId,
                  speed: locationData.speed,
                  heading: locationData.heading,
                )
                .catchError((error) {
                  // Log error and emit error event
                  debugPrint('Location update failed (background): $error');
                  add(LocationEvent.errorOccurred(error.toString()));
                });
          }
        },
        onError: (error) {
          debugPrint('Background location stream error: $error');
          add(LocationEvent.errorOccurred(error.toString()));
        },
        cancelOnError: false, // Continue tracking even if errors occur
      );

      // Also start foreground tracking for immediate updates
      debugPrint('LocationBloc: Starting foreground location stream...');
      _streamSubscription =
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 10, // Update every 10 meters
              timeLimit: Duration(seconds: 5), // Or every 5 seconds
            ),
          ).listen(
            (Position position) {
              // Send location update to server
              debugPrint(
                'LocationBloc: Foreground stream received position: ${position.latitude}, ${position.longitude}',
              );
              service
                  .update(
                    latitude: position.latitude,
                    longitude: position.longitude,
                    packageId: _currentPackageId,
                    speed: position.speed,
                    heading: position.heading,
                  )
                  .then((_) {
                    debugPrint(
                      'LocationBloc: Foreground location update sent successfully',
                    );
                  })
                  .catchError((error) {
                    // Log error and emit error event
                    debugPrint('Location update failed (foreground): $error');
                    add(LocationEvent.errorOccurred(error.toString()));
                  });
            },
            onError: (error) {
              add(LocationEvent.errorOccurred(error.toString()));
            },
          );

      // Also send initial location immediately
      // This is critical - ensures rider appears on map right after login
      try {
        debugPrint('Fetching initial location...');
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10), // Don't wait too long
        );
        debugPrint(
          'Got initial position: ${position.latitude}, ${position.longitude}',
        );

        await service.update(
          latitude: position.latitude,
          longitude: position.longitude,
          packageId: event.packageId,
          speed: position.speed,
          heading: position.heading,
        );

        if (kDebugMode) {
          debugPrint(
            'Initial location sent successfully: ${position.latitude}, ${position.longitude}',
          );
        }
      } catch (e) {
        // Initial location fetch failed, but stream will continue
        debugPrint('Initial location fetch failed: $e');
        debugPrint(
          'Location streams will continue, but initial location was not sent.',
        );
        // Don't emit error state - let streams handle it
        // The foreground and background streams will send location once they get a fix
      }
    });

    on<_Stop>((event, emit) async {
      _timer?.cancel();
      _streamSubscription?.cancel();
      _backgroundStreamSubscription?.cancel();

      // Disable background mode
      if (_backgroundLocation != null) {
        await _backgroundLocation?.enableBackgroundMode(enable: false);
      }

      _currentPackageId = null;
      emit(const LocationState.idle());
    });

    on<_ErrorOccurred>((event, emit) {
      // Log error but don't stop tracking
      // Only emit error state if we're not already tracking
      // This prevents error messages from flashing while tracking is active
      if (state is _Idle) {
        emit(LocationState.error(event.error));
      }
      // If already tracking, silently continue (errors are logged in service)
    });
  }

  final LocationService service;
  Timer? _timer;
  StreamSubscription<Position>? _streamSubscription;
  StreamSubscription<location_package.LocationData>?
  _backgroundStreamSubscription;
  location_package.Location? _backgroundLocation;
  int? _currentPackageId;

  @override
  Future<void> close() {
    _timer?.cancel();
    _streamSubscription?.cancel();
    _backgroundStreamSubscription?.cancel();

    // Disable background mode
    _backgroundLocation?.enableBackgroundMode(enable: false);

    return super.close();
  }
}
