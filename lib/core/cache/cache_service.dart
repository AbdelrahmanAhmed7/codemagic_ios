import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mediconsult/features/home/data/home_response_model.dart';
import 'package:mediconsult/features/family_members/data/family_response_model.dart';
import 'package:mediconsult/features/approval_request/data/approvals_models.dart';
import 'package:mediconsult/features/notifications/data/notification_models.dart';

class CacheService {
  // Home Cache
  static const String _homeDataKey = 'home_data';
  static const String _lastUpdateKey = 'home_last_update';
  static const int _cacheExpiryHours = 1;

  // Family Members Cache
  static const String _familyDataKey = 'family_data';
  static const String _familyLastUpdateKey = 'family_last_update';
  static const int _familyCacheExpiryHours = 24;

  // Approvals Cache
  static const String _approvalsDataKey = 'approvals_data';
  static const String _approvalsLastUpdateKey = 'approvals_last_update';
  static const int _approvalsCacheExpiryMinutes = 10;

  // Notifications Cache
  static const String _notificationsDataKey = 'notifications_data';
  static const String _notificationsLastUpdateKey = 'notifications_last_update';
  static const int _notificationsCacheExpiryMinutes = 5;

    // cache home data
  static Future<void> cacheHomeData(HomeResponse data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.toJson());
    await prefs.setString(_homeDataKey, jsonString);
    await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

    // get cached home data
  static Future<HomeResponse?> getCachedHomeData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_homeDataKey);
    final lastUpdate = prefs.getInt(_lastUpdateKey);
    
    if (jsonString == null || lastUpdate == null) {
      return null;
    }

    // check if cache is expired
    final now = DateTime.now().millisecondsSinceEpoch;
    final cacheAge = now - lastUpdate;
    final cacheExpiryMs = _cacheExpiryHours * 60 * 60 * 1000;

    if (cacheAge > cacheExpiryMs) {
      await clearCache();
      return null;
    }

    try {
      final jsonData = jsonDecode(jsonString);
      return HomeResponse.fromJson(jsonData);
    } catch (e) {
      await clearCache();
      return null;
    }
  }

    // clear cache
    static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_homeDataKey);
    await prefs.remove(_lastUpdateKey);
  }

    // check if cache has valid data
  static Future<bool> hasValidCache() async {
    final data = await getCachedHomeData();
    return data != null;
  }

  // ==================== Family Members Cache ====================
  
  static Future<void> cacheFamilyData(FamilyResponse data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.toJson());
    await prefs.setString(_familyDataKey, jsonString);
    await prefs.setInt(_familyLastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<FamilyResponse?> getCachedFamilyData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_familyDataKey);
    final lastUpdate = prefs.getInt(_familyLastUpdateKey);
    
    if (jsonString == null || lastUpdate == null) {
      return null;
    }

    // check if cache is expired (24 hours)
    final now = DateTime.now().millisecondsSinceEpoch;
    final cacheAge = now - lastUpdate;
    final cacheExpiryMs = _familyCacheExpiryHours * 60 * 60 * 1000;

    if (cacheAge > cacheExpiryMs) {
      await clearFamilyCache();
      return null;
    }

    try {
      final jsonData = jsonDecode(jsonString);
      return FamilyResponse.fromJson(jsonData);
    } catch (e) {
      await clearFamilyCache();
      return null;
    }
  }

  static Future<void> clearFamilyCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_familyDataKey);
    await prefs.remove(_familyLastUpdateKey);
  }

  // ==================== Approvals Cache ====================
  
  static Future<void> cacheApprovalsData(ApprovalsResponse data, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.toJson());
    await prefs.setString('${_approvalsDataKey}_$status', jsonString);
    await prefs.setInt('${_approvalsLastUpdateKey}_$status', DateTime.now().millisecondsSinceEpoch);
  }

  static Future<ApprovalsResponse?> getCachedApprovalsData(String status) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('${_approvalsDataKey}_$status');
    final lastUpdate = prefs.getInt('${_approvalsLastUpdateKey}_$status');
    
    if (jsonString == null || lastUpdate == null) {
      return null;
    }

    // check if cache is expired (10 minutes)
    final now = DateTime.now().millisecondsSinceEpoch;
    final cacheAge = now - lastUpdate;
    final cacheExpiryMs = _approvalsCacheExpiryMinutes * 60 * 1000;

    if (cacheAge > cacheExpiryMs) {
      await clearApprovalsCache(status);
      return null;
    }

    try {
      final jsonData = jsonDecode(jsonString);
      return ApprovalsResponse.fromJson(jsonData);
    } catch (e) {
      await clearApprovalsCache(status);
      return null;
    }
  }

  static Future<void> clearApprovalsCache(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_approvalsDataKey}_$status');
    await prefs.remove('${_approvalsLastUpdateKey}_$status');
  }

  static Future<void> clearAllApprovalsCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_approvalsDataKey) || key.startsWith(_approvalsLastUpdateKey)) {
        await prefs.remove(key);
      }
    }
  }

  // ==================== Notifications Cache ====================
  
  static Future<void> cacheNotificationsData(NotificationsResponse data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.toJson());
    await prefs.setString(_notificationsDataKey, jsonString);
    await prefs.setInt(_notificationsLastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<NotificationsResponse?> getCachedNotificationsData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_notificationsDataKey);
    final lastUpdate = prefs.getInt(_notificationsLastUpdateKey);
    
    if (jsonString == null || lastUpdate == null) {
      return null;
    }

    // check if cache is expired (5 minutes)
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

  static Future<void> clearNotificationsCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationsDataKey);
    await prefs.remove(_notificationsLastUpdateKey);
  }
}
