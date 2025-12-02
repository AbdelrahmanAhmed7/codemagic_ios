import 'package:flutter/material.dart';
import 'package:mediconsult/core/theming/app_colors.dart';

void showAppSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
  Duration duration = const Duration(seconds: 2),
}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;

  // إخفاء أي SnackBar موجود مسبقاً
  messenger.hideCurrentSnackBar();

  final Color bgColor = isError
      ? Colors.redAccent.shade200
      : AppColors.greenClrW.withValues(alpha: 0.9);

  final IconData icon = isError
      ? Icons.error_rounded
      : Icons.check_circle_rounded;

  // عرض SnackBar جديد
  messenger.showSnackBar(
    SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      duration: duration,
      dismissDirection: DismissDirection.horizontal,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              bgColor,
              isError ? Colors.red.shade700 : AppColors.greenClrW,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  // إجبار الإخفاء بعد المدة المحددة (حتى لو المستخدم ما داس dismiss)
  Future.delayed(duration, () {
    if (context.mounted) {
      messenger.hideCurrentSnackBar();
    }
  });
}
