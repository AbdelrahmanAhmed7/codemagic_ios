import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class ApprovalEmptyState extends StatelessWidget {
  const ApprovalEmptyState({super.key, this.onCreate});
  final VoidCallback? onCreate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 100.h),
        Image.asset(
          AppAssets.emptyState,
          width: 300.w,
          height: 250.h,
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.font14BlackMedium,
              children: [
                const TextSpan(
                    text: "You don't have any requests click\nbutton "),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2563EB),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 16),
                  ),
                ),
                const TextSpan(text: " to request approval"),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Image.asset(
          AppAssets.arrow,
          width: 162.w,
          height: 162.h,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: AppColors.primaryClr,
              onPressed: onCreate ?? () => context.go('/approval-request/form'),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}


