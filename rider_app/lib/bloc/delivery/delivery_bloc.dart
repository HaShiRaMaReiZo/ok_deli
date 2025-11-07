import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../repositories/rider_package_repository.dart';

part 'delivery_event.dart';
part 'delivery_state.dart';
part 'delivery_bloc.freezed.dart';

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  DeliveryBloc({required this.repository}) : super(const DeliveryState.idle()) {
    on<_StartDelivery>((event, emit) async {
      emit(const DeliveryState.loading());
      try {
        await repository.startDelivery(event.packageId);
        emit(const DeliveryState.success(message: 'Started'));
        emit(const DeliveryState.idle());
      } catch (e) {
        emit(DeliveryState.failure(message: e.toString()));
      }
    });

    on<_UpdateStatus>((event, emit) async {
      emit(const DeliveryState.loading());
      try {
        await repository.updateStatus(
          event.packageId,
          event.status,
          notes: event.notes,
          lat: event.lat,
          lng: event.lng,
        );
        emit(const DeliveryState.success(message: 'Updated'));
        emit(const DeliveryState.idle());
      } catch (e) {
        emit(DeliveryState.failure(message: e.toString()));
      }
    });

    on<_ContactCustomer>((event, emit) async {
      emit(const DeliveryState.loading());
      try {
        await repository.contactCustomer(
          event.packageId,
          success: event.success,
          notes: event.notes,
        );
        emit(const DeliveryState.success(message: 'Contact logged'));
        emit(const DeliveryState.idle());
      } catch (e) {
        emit(DeliveryState.failure(message: e.toString()));
      }
    });

    on<_CollectCod>((event, emit) async {
      emit(const DeliveryState.loading());
      try {
        await repository.collectCod(
          event.packageId,
          amount: event.amount,
          imagePath: event.imagePath,
        );
        emit(const DeliveryState.success(message: 'COD collected'));
        emit(const DeliveryState.idle());
      } catch (e) {
        emit(DeliveryState.failure(message: e.toString()));
      }
    });
  }

  final RiderPackageRepository repository;
}
