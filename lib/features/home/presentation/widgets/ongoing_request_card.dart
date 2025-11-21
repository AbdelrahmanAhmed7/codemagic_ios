import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/features/home/data/home_response_model.dart';

/// Individual approval card in ongoing requests list
class OngoingRequestCard extends StatelessWidget {
  final Approval approval;

  const OngoingRequestCard({
    super.key,
    required this.approval,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final statusLabel = _statusLabel(approval.status);

    // Wrap in RepaintBoundary for better scroll performance
    return RepaintBoundary(
      child: Directionality(
      textDirection: isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 140.h,
            decoration: BoxDecoration(
              color: AppColors.whiteClr,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.greyClr.withValues(alpha: 0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: AppColors.greyClr.withValues(alpha: 0.05),
                  blurRadius: 30,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Provider logo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: approval.providerLogo.isNotEmpty
                            ? Image.network(
                                approval.providerLogo,
                                width: 48.w,
                                height: 60.h,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  AppAssets.alfaLogo,
                                  width: 48.w,
                                  height: 60.h,
                                ),
                              )
                            : Image.asset(
                                AppAssets.logo,
                                width: 48.w,
                                height: 60.h,
                              ),
                      ),
                      SizedBox(width: 12.w),

                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              approval.providerName.trim(),
                              style: AppTextStyles.font14BlackMedium(context)
                                  .copyWith(color: const Color(0xff062860)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              "${'home.service_type'.tr()}: ${approval.notes.isNotEmpty ? approval.notes : 'home.no_notes'.tr()}",
                              style: AppTextStyles.font12GreyRegular(context),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              "${'home.date'.tr()}: ${approval.createdDate.split('T').first}",
                              style: AppTextStyles.font10GreyRegular(context),
                            ),
                          ],
                        ),
                      ),

                      // Arrow
                      Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Transform.rotate(
                          angle: isArabic ? 3.1416 : 0,
                          child: Image.asset(
                            AppAssets.arrowRight,
                            width: 25.w,
                            height: 20.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Status Badge
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(approval.status)
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        statusLabel,
                        style: AppTextStyles.font10GreyRegular(context)
                            .copyWith(
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(approval.status),
                              fontSize: 9.sp,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 6.w,
              decoration: BoxDecoration(
                color: _getStatusColor(approval.status),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  bottomLeft: Radius.circular(12.r),
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  static Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "approved":
        return Colors.green;
      case "under review":
        return const Color(0xFFFFC888);
      case "rejected":
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  static String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'A':
        return 'approval_history.status.approved'.tr();
      case 'R':
        return 'approval_history.status.rejected'.tr();
      case 'P':
      default:
        return 'approval_history.status.pending'.tr();
    }
  }
}

