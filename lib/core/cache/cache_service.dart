// Facade pattern - unified interface for all cache services
// This file delegates to specific cache services while maintaining backward compatibility

import 'package:mediconsult/features/home/data/home_response_model.dart';
import 'package:mediconsult/features/family_members/data/family_response_model.dart';
import 'package:mediconsult/features/approval_request/data/approvals_models.dart';
import 'package:mediconsult/features/notifications/data/notification_models.dart';

// Import specific cache services
import 'home_cache_service.dart';
import 'family_cache_service.dart';
import 'approvals_cache_service.dart';
import 'notifications_cache_service.dart';
import 'network_cache_service.dart';
import 'support_cache_service.dart';
import 'profile_cache_service.dart';
import 'terms_cache_service.dart';
import 'refunds_cache_service.dart';

/// Unified cache service facade
/// Delegates to specific cache services for better code organization and performance
class CacheService {
  // ==================== Home Cache ====================
  
  /// Cache home data
  static Future<void> cacheHomeData(HomeResponse data) async {
    return HomeCacheService.cacheHomeData(data);
  }

  /// Get cached home data
  static Future<HomeResponse?> getCachedHomeData() async {
    return HomeCacheService.getCachedHomeData();
  }

  /// Clear home cache
  static Future<void> clearCache() async {
    return HomeCacheService.clearCache();
  }

  /// Check if cache has valid data
  static Future<bool> hasValidCache() async {
    return HomeCacheService.hasValidCache();
  }

  // ==================== Family Members Cache ====================
  
  /// Cache family data
  static Future<void> cacheFamilyData(FamilyResponse data) async {
    return FamilyCacheService.cacheFamilyData(data);
  }

  /// Get cached family data
  static Future<FamilyResponse?> getCachedFamilyData() async {
    return FamilyCacheService.getCachedFamilyData();
  }

  /// Clear family cache
  static Future<void> clearFamilyCache() async {
    return FamilyCacheService.clearFamilyCache();
  }

  // ==================== Approvals Cache ====================
  
  /// Cache approvals data
  static Future<void> cacheApprovalsData(ApprovalsResponse data, String status) async {
    return ApprovalsCacheService.cacheApprovalsData(data, status);
  }

  /// Get cached approvals data
  static Future<ApprovalsResponse?> getCachedApprovalsData(String status) async {
    return ApprovalsCacheService.getCachedApprovalsData(status);
  }

  /// Clear approvals cache for specific status
  static Future<void> clearApprovalsCache(String status) async {
    return ApprovalsCacheService.clearApprovalsCache(status);
  }

  /// Clear all approvals cache
  static Future<void> clearAllApprovalsCache() async {
    return ApprovalsCacheService.clearAllApprovalsCache();
  }

  // ==================== Notifications Cache ====================
  
  /// Cache notifications data
  static Future<void> cacheNotificationsData(NotificationsResponse data) async {
    return NotificationsCacheService.cacheNotificationsData(data);
  }

  /// Get cached notifications data
  static Future<NotificationsResponse?> getCachedNotificationsData() async {
    return NotificationsCacheService.getCachedNotificationsData();
  }

  /// Clear notifications cache
  static Future<void> clearNotificationsCache() async {
    return NotificationsCacheService.clearNotificationsCache();
  }

  // ==================== Network Cache ====================
  
  /// Cache network categories data
  static Future<void> cacheNetworkCategoriesData(dynamic data) async {
    return NetworkCacheService.cacheNetworkCategoriesData(data);
  }

  /// Get cached network categories data
  static Future<dynamic> getCachedNetworkCategoriesData() async {
    return NetworkCacheService.getCachedNetworkCategoriesData();
  }

  /// Clear network categories cache
  static Future<void> clearNetworkCategoriesCache() async {
    return NetworkCacheService.clearNetworkCategoriesCache();
  }

  /// Cache network governments data
  static Future<void> cacheNetworkGovernmentsData(dynamic data) async {
    return NetworkCacheService.cacheNetworkGovernmentsData(data);
  }

  /// Get cached network governments data
  static Future<dynamic> getCachedNetworkGovernmentsData() async {
    return NetworkCacheService.getCachedNetworkGovernmentsData();
  }

  /// Clear network governments cache
  static Future<void> clearNetworkGovernmentsCache() async {
    return NetworkCacheService.clearNetworkGovernmentsCache();
  }

  /// Cache network cities data
  static Future<void> cacheNetworkCitiesData(int governmentId, dynamic data) async {
    return NetworkCacheService.cacheNetworkCitiesData(governmentId, data);
  }

  /// Get cached network cities data
  static Future<dynamic> getCachedNetworkCitiesData(int governmentId) async {
    return NetworkCacheService.getCachedNetworkCitiesData(governmentId);
  }

  /// Clear network cities cache for specific government
  static Future<void> clearNetworkCitiesCache(int governmentId) async {
    return NetworkCacheService.clearNetworkCitiesCache(governmentId);
  }

  /// Clear all network cities cache
  static Future<void> clearAllNetworkCitiesCache() async {
    return NetworkCacheService.clearAllNetworkCitiesCache();
  }

  // ==================== Support (Contacts/FAQs) Cache ====================
  static Future<void> cacheContactsData(dynamic data) async {
    return SupportCacheService.cacheContactsData(data);
  }

  static Future<dynamic> getCachedContactsData() async {
    return SupportCacheService.getCachedContactsData();
  }

  static Future<void> cacheFaqsData(dynamic data) async {
    return SupportCacheService.cacheFaqsData(data);
  }

  static Future<dynamic> getCachedFaqsData() async {
    return SupportCacheService.getCachedFaqsData();
  }

  // ==================== Profile Cache ====================
  static Future<void> cachePersonalInfo(dynamic data) async {
    return ProfileCacheService.cachePersonalInfo(data);
  }

  static Future<dynamic> getCachedPersonalInfo() async {
    return ProfileCacheService.getCachedPersonalInfo();
  }

  // ==================== Terms & Privacy Cache ====================
  static Future<void> cacheTerms(dynamic data) async {
    return TermsCacheService.cacheTerms(data);
  }

  static Future<dynamic> getCachedTerms() async {
    return TermsCacheService.getCachedTerms();
  }

  static Future<void> cachePrivacy(dynamic data) async {
    return TermsCacheService.cachePrivacy(data);
  }

  static Future<dynamic> getCachedPrivacy() async {
    return TermsCacheService.getCachedPrivacy();
  }

  // ==================== Refunds Cache ====================
  
  /// Cache refunds data
  static Future<void> cacheRefundsData(dynamic data, String status) async {
    return RefundsCacheService.cacheRefundsData(data, status);
  }

  /// Get cached refunds data
  static Future<dynamic> getCachedRefundsData(String status) async {
    return RefundsCacheService.getCachedRefundsData(status);
  }

  /// Clear refunds cache for specific status
  static Future<void> clearRefundsCache(String status) async {
    return RefundsCacheService.clearRefundsCache(status);
  }

  /// Clear all refunds cache
  static Future<void> clearAllRefundsCache() async {
    return RefundsCacheService.clearAllRefundsCache();
  }
}
