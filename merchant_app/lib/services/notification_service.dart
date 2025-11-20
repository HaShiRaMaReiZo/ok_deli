import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../core/api_endpoints.dart';
import '../core/api_client.dart';

class NotificationService {
  NotificationService({required this.apiClient}) {
    _localNotifications = FlutterLocalNotificationsPlugin();
    _firebaseMessaging = FirebaseMessaging.instance;
    _initializeLocalNotifications();
  }

  final ApiClient apiClient;
  late FlutterLocalNotificationsPlugin _localNotifications;
  late FirebaseMessaging _firebaseMessaging;
  String? _fcmToken;
  StreamSubscription<String>? _tokenSubscription;

  // Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for iOS
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Request notification permissions
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // Request FCM permissions
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    // You can navigate to specific screens based on notification data
  }

  // Initialize and get FCM token
  Future<String?> initialize() async {
    try {
      // Get FCM token
      _fcmToken = await _firebaseMessaging.getToken();

      // Listen for token refresh
      _tokenSubscription = _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        _updateTokenOnServer(newToken);
      });

      // Set up message handlers
      _setupMessageHandlers();

      // Send token to server
      if (_fcmToken != null) {
        await _updateTokenOnServer(_fcmToken!);
      }

      return _fcmToken;
    } catch (e) {
      return null;
    }
  }

  void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });

    // Handle background messages (when app is in background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message);
    });

    // Check if app was opened from a notification
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _handleNotificationTap(message);
      }
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;

    if (notification != null) {
      const androidDetails = AndroidNotificationDetails(
        'delivery_express',
        'Package Updates',
        channelDescription: 'Notifications for package status updates',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        details,
        payload: message.data.toString(),
      );
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    // Handle navigation based on notification data
    // You can use a navigator key or event bus to navigate
    // For now, we'll just log it
  }

  Future<void> _updateTokenOnServer(String token) async {
    try {
      await apiClient.raw.post(
        '${ApiEndpoints.baseUrl}/api/notifications/register-token',
        data: {'fcm_token': token, 'device_type': 'mobile'},
      );
    } catch (e) {
      // Handle error silently
    }
  }

  // Unregister token when user logs out
  Future<void> unregister() async {
    try {
      if (_fcmToken != null) {
        await apiClient.raw.post(
          '${ApiEndpoints.baseUrl}/api/notifications/unregister-token',
          data: {'fcm_token': _fcmToken},
        );
      }
      _tokenSubscription?.cancel();
      _fcmToken = null;
    } catch (e) {
      // Handle error silently
    }
  }

  void dispose() {
    _tokenSubscription?.cancel();
  }
}

// Top-level function for background message handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages here
  // This function must be top-level or static
}
