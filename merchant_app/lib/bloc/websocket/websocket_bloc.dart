import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../../services/websocket_service.dart';

part 'websocket_event.dart';
part 'websocket_state.dart';
part 'websocket_bloc.freezed.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  WebSocketBloc({required this.service})
    : super(const WebSocketState.disconnected()) {
    on<_Connect>((event, emit) async {
      try {
        await service.connect();
        emit(const WebSocketState.connected());
      } catch (e) {
        emit(WebSocketState.error(e.toString()));
      }
    });

    on<_Disconnect>((event, emit) async {
      service.disconnect();
      emit(const WebSocketState.disconnected());
    });

    on<_SubscribeToMerchant>((event, emit) async {
      final channel = await service.subscribeToMerchantChannel(
        event.merchantId,
      );
      if (channel != null) {
        // Set up event listener on the channel
        channel.onEvent = (dynamic eventData) {
          if (eventData is PusherEvent &&
              eventData.eventName == 'package.status.changed') {
            try {
              final data = eventData.data is String
                  ? eventData.data
                  : jsonEncode(eventData.data);
              add(WebSocketEvent.packageStatusChanged(data));
            } catch (e) {
              // Handle parsing error
            }
          }
        };
        emit(WebSocketState.subscribedToMerchant(event.merchantId));
      }
    });

    on<_SubscribeToPackageLocation>((event, emit) async {
      final channel = await service.subscribeToPackageLocationChannel(
        event.packageId,
      );
      if (channel != null) {
        // Set up event listener on the channel
        channel.onEvent = (dynamic eventData) {
          if (eventData is PusherEvent &&
              eventData.eventName == 'rider.location.updated') {
            try {
              final data = eventData.data is String
                  ? eventData.data
                  : jsonEncode(eventData.data);
              add(WebSocketEvent.riderLocationUpdated(event.packageId, data));
            } catch (e) {
              // Handle parsing error
            }
          }
        };
        emit(WebSocketState.subscribedToPackageLocation(event.packageId));
      }
    });

    on<_UnsubscribeFromPackageLocation>((event, emit) async {
      await service.unsubscribeFromPackageLocationChannel(event.packageId);
      emit(const WebSocketState.connected());
    });

    on<_PackageStatusChanged>((event, emit) {
      // Emit a state that includes the package status change data
      emit(WebSocketState.packageUpdateReceived(event.data));
      // Then return to connected state
      emit(const WebSocketState.connected());
    });

    on<_RiderLocationUpdated>((event, emit) {
      // Emit a state that includes the rider location update data
      emit(
        WebSocketState.riderLocationUpdateReceived(event.packageId, event.data),
      );
      // Then return to connected state
      emit(const WebSocketState.connected());
    });
  }

  final WebSocketService service;

  @override
  Future<void> close() {
    service.disconnect();
    return super.close();
  }
}
