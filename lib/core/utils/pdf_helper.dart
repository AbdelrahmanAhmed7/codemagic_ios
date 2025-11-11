import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mediconsult/core/constants/api_result.dart';
import 'package:mediconsult/features/approval_request/data/approvals_models.dart';

/// Helper class for opening PDF documents
class PdfHelper {
  /// Opens a PDF from an API result
  /// Shows loading dialog, fetches PDF URL, and opens it in external app
  static Future<void> openPdf({
    required BuildContext context,
    required Future<ApiResult<ApprovalPdfResponse>> Function() fetchPdf,
    String? errorMessageKey,
  }) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final result = await fetchPdf();

      // Close loading dialog
      if (context.mounted) Navigator.pop(context);

      result.when(
        success: (response) async {
          if (response.data?.url != null) {
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
          }
        },
        failure: (error) {
          if (context.mounted) {
            _showError(context, error);
          }
        },
      );
    } catch (e) {
      // Close loading dialog if still open
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) {
        _showError(
          context,
          errorMessageKey ?? 'common.error_loading_pdf',
        );
      }
    }
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message.tr())),
    );
  }
}
