import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TermsCacheService {
  static const String _termsKey = 'terms_html';
  static const String _privacyKey = 'privacy_html';
  static const String _termsUpdatedKey = 'terms_last_update';
  static const String _privacyUpdatedKey = 'privacy_last_update';
  static const int _expiryHours = 168;

  static Future<void> cacheTerms(dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_termsKey, jsonEncode(data));
    await prefs.setInt(_termsUpdatedKey, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<dynamic> getCachedTerms() async {
    final prefs = await SharedPreferences.getInstance();
    final body = prefs.getString(_termsKey);
    final ts = prefs.getInt(_termsUpdatedKey);
    if (body == null || ts == null) return null;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - ts > _expiryHours * 60 * 60 * 1000) {
      await prefs.remove(_termsKey);
      await prefs.remove(_termsUpdatedKey);
      return null;
    }
    try {
      return jsonDecode(body);
    } catch (_) {
      await prefs.remove(_termsKey);
      await prefs.remove(_termsUpdatedKey);
      return null;
    }
  }

  static Future<void> cachePrivacy(dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_privacyKey, jsonEncode(data));
    await prefs.setInt(_privacyUpdatedKey, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<dynamic> getCachedPrivacy() async {
    final prefs = await SharedPreferences.getInstance();
    final body = prefs.getString(_privacyKey);
    final ts = prefs.getInt(_privacyUpdatedKey);
    if (body == null || ts == null) return null;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - ts > _expiryHours * 60 * 60 * 1000) {
      await prefs.remove(_privacyKey);
      await prefs.remove(_privacyUpdatedKey);
      return null;
    }
    try {
      return jsonDecode(body);
    } catch (_) {
      await prefs.remove(_privacyKey);
      await prefs.remove(_privacyUpdatedKey);
      return null;
    }
  }
}


