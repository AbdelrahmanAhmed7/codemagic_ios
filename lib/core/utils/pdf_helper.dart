import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/approval_request/data/approvals_models.dart';
import 'package:url_launcher/url_launcher.dart';

/// Helper class for opening PDF documents
class PdfHelper {
  /// Opens a PDF from an API result
  /// Shows loading dialog, fetches PDF URL, and opens it in external app
  static Future<void> openPdf({
    required BuildContext context,
    required Future<ApiResult<ApprovalPdfResponse>> Function() fetchPdf,
    String? errorMessageKey,
  }) async {
    if (!context.mounted) return;

    bool dialogShown = false;

    try {
      // Show loading indicator
      showDialog(
        context: context,
        useRootNavigator: true,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      dialogShown = true;

      final result = await fetchPdf();

      // Close loading dialog
      if (dialogShown && context.mounted) {
        try {
          Navigator.of(context, rootNavigator: true).pop();
          dialogShown = false;
        } catch (e) {
          // Dialog already closed
        }
      }

      // Small delay to ensure dialog is closed
      await Future.delayed(const Duration(milliseconds: 150));

      if (!context.mounted) return;

      result.when(
        success: (response) async {
          if (response.data?.url != null && response.data!.url.isNotEmpty) {
            final url = Uri.parse(response.data!.url);
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else {
              if (context.mounted) {
                _showError(
                  context,
                  errorMessageKey ?? 'common.cannot_open_pdf',
                );
              }
            }
          } else {
            if (context.mounted) {
              _showError(
                context,
                errorMessageKey ?? 'common.pdf_not_available',
              );
            }
          }
        },
        failure: (error) {
          if (context.mounted) {
            // Parse error message for better UX
            String errorMsg = error;
            if (error.contains('Approval not found') || error.contains('404')) {
              errorMsg = 'approval_history.approval_not_found';
            } else if (error.contains('timeout') ||
                error.contains('Request timeout')) {
              errorMsg = 'common.request_timeout';
            }
            _showError(context, errorMsg);
          }
        },
      );
    } catch (e) {
      // Ensure loading dialog is closed
      if (dialogShown && context.mounted) {
        try {
          Navigator.of(context, rootNavigator: true).pop();
        } catch (e) {
          // Dialog already closed
        }
      }

      await Future.delayed(const Duration(milliseconds: 150));

      if (context.mounted) {
        _showError(context, errorMessageKey ?? 'common.error_loading_pdf');
      }
    }
  }

  static void _showError(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    // إخفاء أي SnackBar موجود مسبقاً
    messenger.hideCurrentSnackBar();

    // عرض SnackBar جديد
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 24.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                message.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFD32F2F),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        duration: const Duration(seconds: 3),
        dismissDirection: DismissDirection.horizontal,
        action: SnackBarAction(
          label: 'common.dismiss'.tr(),
          textColor: Colors.white,
          onPressed: () {
            messenger.hideCurrentSnackBar();
          },
        ),
      ),
    );

    // إجبار الإخفاء بعد 3 ثواني (حتى لو المستخدم ما داس dismiss)
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        messenger.hideCurrentSnackBar();
      }
    });
  }
}
