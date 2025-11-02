import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mediconsult/features/notifications/data/notification_models.dart';

/// Notifications cache service - handles caching for notifications data
class NotificationsCacheService {
  static const String _notificationsDataKey = 'notifications_data';
  static const String _notificationsLastUpdateKey = 'notifications_last_update';
  static const int _notificationsCacheExpiryMinutes = 5;

  /// Cache notifications data
  static Future<void> cacheNotificationsData(NotificationsResponse data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.toJson());
    await prefs.setString(_notificationsDataKey, jsonString);
    await prefs.setInt(_notificationsLastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Get cached notifications data
  static Future<NotificationsResponse?> getCachedNotificationsData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_notificationsDataKey);
    final lastUpdate = prefs.getInt(_notificationsLastUpdateKey);

    if (jsonString == null || lastUpdate == null) {
      return null;
    }

    // Check if cache is expired (5 minutes)
    final now = DateTime.now().millisecondsSinceEpoch;
    final cacheAge = now - lastUpdate;
    final cacheExpiryMs = _notificationsCacheExpiryMinutes * 60 * 1000;

    if (cacheAge > cacheExpiryMs) {
      await clearNotificationsCache();
      return null;
    }

    try {
      final jsonData = jsonDecode(jsonString);
      return NotificationsResponse.fromJson(jsonData);
    } catch (e) {
      await clearNotificationsCache();
      return null;
    }
  }

  /// Clear notifications cache
  static Future<void> clearNotificationsCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationsDataKey);
    await prefs.remove(_notificationsLastUpdateKey);
  }
}

