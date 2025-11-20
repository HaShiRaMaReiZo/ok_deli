import 'dart:async';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../core/api_endpoints.dart';

class WebSocketService {
  WebSocketService({
    required String token,
    String? pusherKey,
    String? pusherCluster,
  }) : _token = token,
       _pusherKey = pusherKey ?? '',
       _pusherCluster = pusherCluster ?? 'mt1' {
    if (_pusherKey.isNotEmpty) {
      _pusher = PusherChannelsFlutter.getInstance();
      _initialized = false;
    }
  }

  final String _token;
  final String _pusherKey;
  final String _pusherCluster;
  PusherChannelsFlutter? _pusher;
  bool _initialized = false;
  final Map<String, PusherChannel> _channels = {};

  bool get isConnected =>
      _pusher?.connectionState == 'CONNECTED' ||
      _pusher?.connectionState == 'CONNECTING';

  Future<void> connect() async {
    if (_pusherKey.isEmpty || _pusher == null) {
      return;
    }

    if (!_initialized) {
      await _pusher!.init(
        apiKey: _pusherKey,
        cluster: _pusherCluster,
        authEndpoint: '${ApiEndpoints.baseUrl}/broadcasting/auth',
        authParams: {
          'headers': {
            'Authorization': 'Bearer $_token',
            'Accept': 'application/json',
          },
        },
      );
      _initialized = true;
    }

    try {
      await _pusher!.connect();
    } catch (e) {
      // Handle connection error
    }
  }

  void disconnect() {
    for (final channel in _channels.values) {
      channel.unsubscribe();
    }
    _channels.clear();
    _pusher?.disconnect();
  }

  Future<PusherChannel?> subscribeToMerchantChannel(int merchantId) async {
    if (_pusherKey.isEmpty || _pusher == null) {
      return null;
    }

    final channelName = 'private-merchant.$merchantId';
    if (_channels.containsKey(channelName)) {
      return _channels[channelName];
    }

    try {
      final channel = await _pusher!.subscribe(channelName: channelName);
      _channels[channelName] = channel;
      return channel;
    } catch (e) {
      return null;
    }
  }

  Future<PusherChannel?> subscribeToPackageLocationChannel(
    int packageId,
  ) async {
    if (_pusherKey.isEmpty || _pusher == null) {
      return null;
    }

    final channelName = 'private-merchant.package.$packageId.location';
    if (_channels.containsKey(channelName)) {
      return _channels[channelName];
    }

    try {
      final channel = await _pusher!.subscribe(channelName: channelName);
      _channels[channelName] = channel;
      return channel;
    } catch (e) {
      return null;
    }
  }

  Future<void> unsubscribeFromChannel(String channelName) async {
    final channel = _channels.remove(channelName);
    if (channel != null) {
      await channel.unsubscribe();
    }
  }

  Future<void> unsubscribeFromPackageLocationChannel(int packageId) async {
    await unsubscribeFromChannel(
      'private-merchant.package.$packageId.location',
    );
  }
}
