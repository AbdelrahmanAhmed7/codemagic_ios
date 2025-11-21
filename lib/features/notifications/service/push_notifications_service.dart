import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('📬 Background message: ${message.messageId}');
  await PushNotificationService.instance.setupFlutterNotifications();
  await PushNotificationService.instance.showNotification(message);
}

/// Production-ready notification service with comprehensive error handling
class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;
  bool _isInitialized = false;

  /// Stream for notification actions (tap/interaction)
  final _notificationActionController =
      StreamController<NotificationAction>.broadcast();
  Stream<NotificationAction> get onNotificationAction =>
      _notificationActionController.stream;

  /// Stream for FCM token updates
  final _tokenController = StreamController<String>.broadcast();
  Stream<String> get onTokenRefresh => _tokenController.stream;

  String? _currentToken;
  String? get currentToken => _currentToken;

  /// Initialize notification service
  /// Call this in main() before runApp()
  Future<bool> initialize() async {
    if (_isInitialized) {
      debugPrint('⚠️ PushNotificationService already initialized');
      return true;
    }

    try {
      debugPrint('🔧 Initializing PushNotificationService...');

      // Set background message handler
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      // Request permissions
      final permissionGranted = await _requestPermission();
      if (!permissionGranted) {
        debugPrint('❌ Notification permission denied');
        return false;
      }

      // Setup local notifications
      await setupFlutterNotifications();

      // Setup message handlers
      await _setupMessageHandlers();

      // Get and listen to FCM token
      await _setupTokenHandling();

      _isInitialized = true;
      debugPrint('✅ PushNotificationService initialized successfully');
      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ Error initializing PushNotificationService: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Request notification permissions
  Future<bool> _requestPermission() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
      );

      final isAuthorized =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;

      debugPrint('🔐 Permission status: ${settings.authorizationStatus}');
      return isAuthorized;
    } catch (e) {
      debugPrint('❌ Error requesting permission: $e');
      return false;
    }
  }

  /// Setup flutter local notifications
  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) return;

    try {
      // Android notification channel
      const channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );

      // Create Android notification channel
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);

      // Initialize settings for both platforms
      const initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      );

      // Initialize plugin
      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _handleNotificationTap,
        onDidReceiveBackgroundNotificationResponse: _handleNotificationTap,
      );

      _isFlutterLocalNotificationsInitialized = true;
      debugPrint('✅ Local notifications initialized');
    } catch (e) {
      debugPrint('❌ Error setting up local notifications: $e');
      rethrow;
    }
  }

  /// Display notification
  Future<void> showNotification(RemoteMessage message) async {
    try {
      final notification = message.notification;
      if (notification == null) {
        debugPrint('⚠️ Message has no notification payload');
        return;
      }

      // Check platform-specific notification data
      final android = message.notification?.android;

      // Prepare notification details
      final androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.high,
        priority: Priority.high,
        icon: android?.smallIcon ?? '@mipmap/ic_launcher',
        playSound: true,
        enableVibration: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.active,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Show notification
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        notificationDetails,
        payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
      );

      debugPrint('✅ Notification shown: ${notification.title}');
    } catch (e) {
      debugPrint('❌ Error showing notification: $e');
    }
  }

  /// Setup message handlers for different app states
  Future<void> _setupMessageHandlers() async {
    try {
      // Foreground messages
      FirebaseMessaging.onMessage.listen((message) {
        debugPrint('📱 Foreground message: ${message.messageId}');
        showNotification(message);
      });

      // Background messages (app in background, user taps notification)
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        debugPrint('👆 Notification opened (background): ${message.messageId}');
        _handleMessageOpen(message);
      });

      // Terminated state (app was closed, user taps notification)
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        debugPrint(
          '🚀 App opened from notification: ${initialMessage.messageId}',
        );
        // Delay to ensure app is fully initialized
        Future.delayed(const Duration(seconds: 1), () {
          _handleMessageOpen(initialMessage);
        });
      }

      debugPrint('✅ Message handlers setup complete');
    } catch (e) {
      debugPrint('❌ Error setting up message handlers: $e');
    }
  }

  /// Setup FCM token handling
  Future<void> _setupTokenHandling() async {
    try {
      // Get initial token
      _currentToken = await _messaging.getToken();
      if (_currentToken != null) {
        debugPrint('🎫 FCM Token: $_currentToken');
        _tokenController.add(_currentToken!);
      }

      // Listen to token refresh
      _messaging.onTokenRefresh.listen((token) {
        debugPrint('🔄 Token refreshed: $token');
        _currentToken = token;
        _tokenController.add(token);
      });
    } catch (e) {
      debugPrint('❌ Error setting up token handling: $e');
    }
  }

  /// Handle notification tap
  @pragma('vm:entry-point')
  static void _handleNotificationTap(NotificationResponse response) {
    debugPrint('👆 Notification tapped: ${response.id}');

    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!) as Map<String, dynamic>;
        instance._notificationActionController.add(
          NotificationAction(
            type: NotificationActionType.tap,
            data: data,
            actionId: response.actionId,
          ),
        );
      } catch (e) {
        debugPrint('❌ Error parsing notification payload: $e');
      }
    }
  }

  /// Handle message open (from FCM directly)
  void _handleMessageOpen(RemoteMessage message) {
    _notificationActionController.add(
      NotificationAction(
        type: NotificationActionType.open,
        data: message.data,
        messageId: message.messageId,
      ),
    );
  }

  /// Subscribe to topic
  Future<bool> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('✅ Subscribed to topic: $topic');
      return true;
    } catch (e) {
      debugPrint('❌ Error subscribing to topic: $e');
      return false;
    }
  }

  /// Unsubscribe from topic
  Future<bool> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('✅ Unsubscribed from topic: $topic');
      return true;
    } catch (e) {
      debugPrint('❌ Error unsubscribing from topic: $e');
      return false;
    }
  }

  /// Delete FCM token
  Future<bool> deleteToken() async {
    try {
      await _messaging.deleteToken();
      _currentToken = null;
      debugPrint('✅ FCM token deleted');
      return true;
    } catch (e) {
      debugPrint('❌ Error deleting token: $e');
      return false;
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _localNotifications.cancelAll();
      debugPrint('✅ All notifications cancelled');
    } catch (e) {
      debugPrint('❌ Error cancelling notifications: $e');
    }
  }

  /// Cancel specific notification
  Future<void> cancelNotification(int id) async {
    try {
      await _localNotifications.cancel(id);
      debugPrint('✅ Notification $id cancelled');
    } catch (e) {
      debugPrint('❌ Error cancelling notification: $e');
    }
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _localNotifications.pendingNotificationRequests();
    } catch (e) {
      debugPrint('❌ Error getting pending notifications: $e');
      return [];
    }
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    if (Platform.isIOS) {
      final settings = await _messaging.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    } else if (Platform.isAndroid) {
      final plugin = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return await plugin?.areNotificationsEnabled() ?? false;
    }
    return false;
  }

  /// Dispose resources
  void dispose() {
    _notificationActionController.close();
    _tokenController.close();
    debugPrint('🧹 PushNotificationService disposed');
  }
}

/// Notification action data model
class NotificationAction {
  final NotificationActionType type;
  final Map<String, dynamic> data;
  final String? actionId;
  final String? messageId;

  NotificationAction({
    required this.type,
    required this.data,
    this.actionId,
    this.messageId,
  });

  @override
  String toString() {
    return 'NotificationAction(type: $type, data: $data, actionId: $actionId, messageId: $messageId)';
  }
}

/// Notification action types
enum NotificationActionType {
  tap, // User tapped on notification
  open, // App opened from notification
}