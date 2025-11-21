import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SupportCacheService {
  // Contacts cache (rarely changes)
  static const String _contactsDataKey = 'support_contacts_data';
  static const String _contactsLastUpdateKey = 'support_contacts_last_update';
  static const int _contactsCacheExpiryHours = 48; // 2 days

  // FAQs cache (rarely changes)
  static const String _faqsDataKey = 'support_faqs_data';
  static const String _faqsLastUpdateKey = 'support_faqs_last_update';
  static const int _faqsCacheExpiryHours = 48; // 2 days

  static Future<void> cacheContactsData(dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_contactsDataKey, jsonEncode(data));
    await prefs.setInt(_contactsLastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<dynamic> getCachedContactsData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_contactsDataKey);
    final lastUpdate = prefs.getInt(_contactsLastUpdateKey);
    if (jsonString == null || lastUpdate == null) return null;
    final now = DateTime.now().millisecondsSinceEpoch;
    final cacheAge = now - lastUpdate;
    final expiry = _contactsCacheExpiryHours * 60 * 60 * 1000;
    if (cacheAge > expiry) {
      await clearContactsCache();
      return null;
    }
    try {
      return jsonDecode(jsonString);
    } catch (_) {
      await clearContactsCache();
      return null;
    }
  }

  static Future<void> clearContactsCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_contactsDataKey);
    await prefs.remove(_contactsLastUpdateKey);
  }

  static Future<void> cacheFaqsData(dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_faqsDataKey, jsonEncode(data));
    await prefs.setInt(_faqsLastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<dynamic> getCachedFaqsData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_faqsDataKey);
    final lastUpdate = prefs.getInt(_faqsLastUpdateKey);
    if (jsonString == null || lastUpdate == null) return null;
    final now = DateTime.now().millisecondsSinceEpoch;
    final cacheAge = now - lastUpdate;
    final expiry = _faqsCacheExpiryHours * 60 * 60 * 1000;
    if (cacheAge > expiry) {
      await clearFaqsCache();
      return null;
    }
    try {
      return jsonDecode(jsonString);
    } catch (_) {
      await clearFaqsCache();
      return null;
    }
  }

  static Future<void> clearFaqsCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_faqsDataKey);
    await prefs.remove(_faqsLastUpdateKey);
  }
}


