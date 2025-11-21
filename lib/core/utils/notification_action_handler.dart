import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mediconsult/core/cache/cache_service.dart';
import 'package:mediconsult/core/constants/constants.dart';
import 'package:mediconsult/core/helpers/shared_pref_helper.dart';
import 'package:mediconsult/features/notifications/data/notification_models.dart';
import 'package:mediconsult/features/approval_request/repository/approvals_repository.dart';
import 'package:mediconsult/core/di/service_locator.dart';
import 'package:mediconsult/core/utils/pdf_helper.dart';

/// Handler for notification actions based on notification data
class NotificationActionHandler {
  /// Handle notification tap and perform appropriate action
  static Future<void> handleNotificationTap(
    BuildContext context,
    NotificationItem notification,
  ) async {
    if (notification.notificationData == null ||
        notification.notificationData!.isEmpty) {
      // No action data, just mark as read
      return;
    }

    // Check for disable action (logout)
    if (notification.hasDataKeyValue('is_disable', '1')) {
      await _handleLogout(context);
      return;
    }

    // Check for refund navigation
    if (notification.hasDataKeyValue('is_refund', '1')) {
      await _navigateToRefunds(context);
      return;
    }

    // Check for approval history navigation
    if (_shouldNavigateToApprovalHistory(notification)) {
      await _navigateToApprovalHistory(context);
      return;
    }

    // Check for approval PDF
    if (_shouldOpenApprovalPdf(notification)) {
      await _openApprovalPdf(context, notification);
      return;
    }
  }

  /// Check if should navigate to approval history
  static bool _shouldNavigateToApprovalHistory(NotificationItem notification) {
    final requestId = notification.getDataValue('request_id');
    final approvalId = notification.getDataValue('approval_id');

    // If has request_id but approval_id is null or 0
    if (requestId != null && requestId.isNotEmpty && requestId != '0') {
      if (approvalId == null || approvalId.isEmpty || approvalId == '0') {
        return true;
      }
    }
    return false;
  }

  /// Check if should open approval PDF
  static bool _shouldOpenApprovalPdf(NotificationItem notification) {
    // Check if has required keys (removed request_id check)
    final isApproved = notification.hasDataKeyValue('is_approved', '1');
    final approvalId = notification.getDataValue('approval_id');
    final hasValidApprovalId =
        approvalId != null && approvalId.isNotEmpty && approvalId != '0';

    return isApproved && hasValidApprovalId;
  }

  /// Handle logout action
  static Future<void> _handleLogout(BuildContext context) async {
    // Show dialog to inform user
    if (!context.mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('notifications.account_disabled'.tr()),
        content: Text('notifications.account_disabled_message'.tr()),
        actions: [
          TextButton(
            onPressed: () async {
              // Clear all data and navigate to login
              await SharedPrefHelper.removeData(SharedPrefKeys.userToken);

              // Clear all cache
              await CacheService.clearCache();
              await CacheService.clearFamilyCache();
              await CacheService.clearAllApprovalsCache();
              await CacheService.clearNotificationsCache();
              Navigator.of(context).pop();
              context.go('/login');
            },
            child: Text('common.ok'.tr()),
          ),
        ],
      ),
    );
  }

  /// Navigate to refunds screen
  static Future<void> _navigateToRefunds(BuildContext context) async {
    if (!context.mounted) return;
    context.push('/refund-history');
  }

  /// Navigate to approval history screen
  static Future<void> _navigateToApprovalHistory(BuildContext context) async {
    if (!context.mounted) return;
    context.push('/approval-history');
  }

  /// Open approval PDF
  static Future<void> _openApprovalPdf(
    BuildContext context,
    NotificationItem notification,
  ) async {
    final approvalId = notification.getDataValue('approval_id');
    if (approvalId == null) return;

    // Convert approval ID to int
    final approvalIdInt = int.tryParse(approvalId);
    if (approvalIdInt == null) return;

    if (!context.mounted) return;

    await PdfHelper.openPdf(
      context: context,
      fetchPdf: () => sl<ApprovalsRepository>().getApprovalPdf(
        lang: context.locale.languageCode,
        approvalId: approvalIdInt,
      ),
      errorMessageKey: 'approval_history.cannot_open_pdf',
    );
  }

  /// Check if notification has any action
  static bool hasAction(NotificationItem notification) {
    if (notification.notificationData == null ||
        notification.notificationData!.isEmpty) {
      return false;
    }

    // Check for any known action
    return notification.hasDataKeyValue('is_disable', '1') ||
        notification.hasDataKeyValue('is_refund', '1') ||
        _shouldNavigateToApprovalHistory(notification) ||
        _shouldOpenApprovalPdf(notification);
  }
}
