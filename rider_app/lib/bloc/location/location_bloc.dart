import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../services/location_service.dart';

part 'location_event.dart';
part 'location_state.dart';
part 'location_bloc.freezed.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc({required this.service}) : super(const LocationState.idle()) {
    on<_Start>((event, emit) async {
      _timer?.cancel();
      emit(const LocationState.active());
      _timer = Timer.periodic(const Duration(seconds: 5), (_) async {
        try {
          await service.update(latitude: event.lat, longitude: event.lng, packageId: event.packageId);
        } catch (_) {}
      });
    });

    on<_Stop>((event, emit) async {
      _timer?.cancel();
      emit(const LocationState.idle());
    });
  }

  final LocationService service;
  Timer? _timer;

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
