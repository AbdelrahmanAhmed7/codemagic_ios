import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mediconsult/features/home/data/home_response_model.dart';

/// Home cache service - handles caching for home data
class HomeCacheService {
  static const String _homeDataKey = 'home_data';
  static const String _lastUpdateKey = 'home_last_update';
  static const int _cacheExpiryHours = 1;

  /// Cache home data
  static Future<void> cacheHomeData(HomeResponse data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.toJson());
    await prefs.setString(_homeDataKey, jsonString);
    await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Get cached home data
  static Future<HomeResponse?> getCachedHomeData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_homeDataKey);
    final lastUpdate = prefs.getInt(_lastUpdateKey);

    if (jsonString == null || lastUpdate == null) {
      return null;
    }

    // Check if cache is expired
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

  /// Clear home cache
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_homeDataKey);
    await prefs.remove(_lastUpdateKey);
  }

  /// Check if cache has valid data
  static Future<bool> hasValidCache() async {
    final data = await getCachedHomeData();
    return data != null;
  }
}

