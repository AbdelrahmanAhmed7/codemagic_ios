import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mediconsult/features/family_members/data/family_response_model.dart';

/// Family members cache service - handles caching for family members data
class FamilyCacheService {
  static const String _familyDataKey = 'family_data';
  static const String _familyLastUpdateKey = 'family_last_update';
  static const int _familyCacheExpiryHours = 24;

  /// Cache family data
  static Future<void> cacheFamilyData(FamilyResponse data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.toJson());
    await prefs.setString(_familyDataKey, jsonString);
    await prefs.setInt(_familyLastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Get cached family data
  static Future<FamilyResponse?> getCachedFamilyData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_familyDataKey);
    final lastUpdate = prefs.getInt(_familyLastUpdateKey);

    if (jsonString == null || lastUpdate == null) {
      return null;
    }

    // Check if cache is expired (24 hours)
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

  /// Clear family cache
  static Future<void> clearFamilyCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_familyDataKey);
    await prefs.remove(_familyLastUpdateKey);
  }
}

