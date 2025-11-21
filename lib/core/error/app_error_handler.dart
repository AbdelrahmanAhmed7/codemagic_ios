import 'package:flutter/material.dart';
import 'package:mediconsult/core/theming/app_colors.dart';

class AppErrorHandler {
  static String getUserFriendlyMessage(String error) {
    if (error.toLowerCase().contains('socketexception') ||
        error.toLowerCase().contains('network')) {
      return 'No internet connection. Please check your network.';
    }
    
    if (error.toLowerCase().contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    
    if (error.contains('401')) {
      return 'Session expired. Please login again.';
    }
    
    if (error.contains('403')) {
      return 'Access denied. You don\'t have permission.';
    }
    
    if (error.contains('404')) {
      return 'Resource not found.';
    }
    
    if (error.contains('500') || error.contains('502') || error.contains('503')) {
      return 'Server error. Please try again later.';
    }
    
    return 'Something went wrong. Please try again.';
  }

  static void showErrorSnackBar(
    BuildContext context,
    String error, {
    VoidCallback? onRetry,
    Duration duration = const Duration(seconds: 4),
  }) {
    final message = getUserFriendlyMessage(error);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorClr,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        action: onRetry != null
            ? SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
      ),
    );
  }

  static void showErrorDialog(
    BuildContext context,
    String error, {
    VoidCallback? onRetry,
  }) {
    final message = getUserFriendlyMessage(error);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.errorClr),
            const SizedBox(width: 8),
            const Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          if (onRetry != null)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onRetry();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryClr,
              ),
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }

  static void logError(String error, {StackTrace? stackTrace}) {
    debugPrint('Error: $error');
    if (stackTrace != null) {
      debugPrint('Stack trace: $stackTrace');
    }
  }
}
