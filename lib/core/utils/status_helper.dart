import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// Helper class for status colors and labels
/// Used for approvals and refunds status display
class StatusHelper {
  /// Get status badge color
  static Color getStatusColor(String statusChar) {
    switch (statusChar.toUpperCase()) {
      case 'A': // Approved
        return const Color(0xFF28A745); // Green - Success
      case 'R': // Rejected
        return const Color(0xFFDC3545); // Red - Danger
      case 'P': // Pending
      default:
        return const Color(0xFFFFC107); // Amber - Warning
    }
  }

  /// Get status background color for card
  static Color getBackgroundColor(String statusChar) {
    switch (statusChar.toUpperCase()) {
      case 'A': // Approved
        return const Color(0xFF28A745).withOpacity(0.1); // Green with 10% opacity
      case 'R': // Rejected
        return const Color(0xFFDC3545).withOpacity(0.1); // Red with 10% opacity
      case 'P': // Pending
      default:
        return const Color(0xFFFFC107).withOpacity(0.1); // Amber with 10% opacity
    }
  }

  /// Get status label text
  /// Uses the provided translation key prefix (e.g., 'approval_history' or 'refund_history')
  static String getStatusLabel(String statusChar, String translationPrefix) {
    switch (statusChar.toUpperCase()) {
      case 'A':
        return '$translationPrefix.status.approved'.tr();
      case 'R':
        return '$translationPrefix.status.rejected'.tr();
      case 'P':
      default:
        return '$translationPrefix.status.pending'.tr();
    }
  }
}
