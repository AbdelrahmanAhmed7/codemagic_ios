import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mediconsult/features/approval_request/data/approvals_models.dart';

/// Approvals cache service - handles caching for approvals data
class ApprovalsCacheService {
  static const String _approvalsDataKey = 'approvals_data';
  static const String _approvalsLastUpdateKey = 'approvals_last_update';
  static const int _approvalsCacheExpiryMinutes = 10;

  /// Cache approvals data
  static Future<void> cacheApprovalsData(ApprovalsResponse data, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.toJson());
    await prefs.setString('${_approvalsDataKey}_$status', jsonString);
    await prefs.setInt('${_approvalsLastUpdateKey}_$status', DateTime.now().millisecondsSinceEpoch);
  }

  /// Get cached approvals data
  static Future<ApprovalsResponse?> getCachedApprovalsData(String status) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('${_approvalsDataKey}_$status');
    final lastUpdate = prefs.getInt('${_approvalsLastUpdateKey}_$status');

    if (jsonString == null || lastUpdate == null) {
      return null;
    }

    // Check if cache is expired (10 minutes)
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

  /// Clear approvals cache for specific status
  static Future<void> clearApprovalsCache(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_approvalsDataKey}_$status');
    await prefs.remove('${_approvalsLastUpdateKey}_$status');
  }

  /// Clear all approvals cache
  static Future<void> clearAllApprovalsCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    // Use batch remove for better performance
    final keysToRemove = keys.where((key) =>
      key.startsWith(_approvalsDataKey) ||
      key.startsWith(_approvalsLastUpdateKey)
    ).toList();
    for (final key in keysToRemove) {
      await prefs.remove(key);
    }
  }
}

