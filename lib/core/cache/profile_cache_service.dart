import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCacheService {
  static const String _personalInfoKey = 'profile_personal_info';
  static const String _personalInfoLastUpdateKey = 'profile_personal_info_last_update';
  static const int _expiryHours = 72;

  static Future<void> cachePersonalInfo(dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_personalInfoKey, jsonEncode(data));
    await prefs.setInt(_personalInfoLastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<dynamic> getCachedPersonalInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_personalInfoKey);
    final lastUpdate = prefs.getInt(_personalInfoLastUpdateKey);
    if (jsonString == null || lastUpdate == null) return null;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - lastUpdate > _expiryHours * 60 * 60 * 1000) {
      await clearPersonalInfo();
      return null;
    }
    try {
      return jsonDecode(jsonString);
    } catch (_) {
      await clearPersonalInfo();
      return null;
    }
  }

  static Future<void> clearPersonalInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_personalInfoKey);
    await prefs.remove(_personalInfoLastUpdateKey);
  }
}


