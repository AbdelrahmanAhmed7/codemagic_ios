import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mediconsult/features/refund/data/refund_list_models.dart';

/// Refunds cache service - handles caching for refunds data
class RefundsCacheService {
  static const String _refundsDataKey = 'refunds_data';
  static const String _refundsLastUpdateKey = 'refunds_last_update';
  static const int _refundsCacheExpiryMinutes = 10;

  /// Cache refunds data
  static Future<void> cacheRefundsData(RefundListResponse data, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.toJson());
    await prefs.setString('${_refundsDataKey}_$status', jsonString);
    await prefs.setInt('${_refundsLastUpdateKey}_$status', DateTime.now().millisecondsSinceEpoch);
  }

  /// Get cached refunds data
  static Future<RefundListResponse?> getCachedRefundsData(String status) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('${_refundsDataKey}_$status');
    final lastUpdate = prefs.getInt('${_refundsLastUpdateKey}_$status');

    if (jsonString == null || lastUpdate == null) {
      return null;
    }

    // Check if cache is expired (10 minutes)
    final now = DateTime.now().millisecondsSinceEpoch;
    final cacheAge = now - lastUpdate;
    final cacheExpiryMs = _refundsCacheExpiryMinutes * 60 * 1000;

    if (cacheAge > cacheExpiryMs) {
      await clearRefundsCache(status);
      return null;
    }

    try {
      final jsonData = jsonDecode(jsonString);
      return RefundListResponse.fromJson(jsonData);
    } catch (e) {
      await clearRefundsCache(status);
      return null;
    }
  }

  /// Clear refunds cache for specific status
  static Future<void> clearRefundsCache(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_refundsDataKey}_$status');
    await prefs.remove('${_refundsLastUpdateKey}_$status');
  }

  /// Clear all refunds cache
  static Future<void> clearAllRefundsCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    // Use batch remove for better performance
    final keysToRemove = keys.where((key) =>
      key.startsWith(_refundsDataKey) ||
      key.startsWith(_refundsLastUpdateKey)
    ).toList();
    for (final key in keysToRemove) {
      await prefs.remove(key);
    }
  }
}
