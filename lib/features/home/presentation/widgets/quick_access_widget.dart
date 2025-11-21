import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mediconsult/shared/widgets/coming_soon_dialog.dart';

class QuickAccessWidget extends StatelessWidget {
  const QuickAccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 10.h),
          child: Text(
            'home.quick_access'.tr(),
            style: AppTextStyles.font14BlackMedium(context).copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuickAccessButton(
                image: AppAssets.approval,
                label: 'home.approval'.tr(),
                color: AppColors.approvalColor,
                textColor: AppColors.approvalTextColor,
                onTap: () {
                  context.push('/approval-history');
                },
                context: context,
              ),
              _buildQuickAccessButton(
                image: AppAssets.refund,
                label: 'home.refund'.tr(),
                color: AppColors.refundColor,
                textColor: AppColors.refundTextColor,
                onTap: () {
                  context.push('/refund-history');
                },
                context: context,
              ),
              _buildQuickAccessButton(
                image: AppAssets.medicine,
                label: 'home.chronic_medicine'.tr(),
                color: AppColors.chronicMedicineColor,
                textColor: AppColors.chronicMedicineTextColor,
                onTap: () {
                  ComingSoonDialog.show(context);
                },
                context: context,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAccessButton({
    required String image,
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                image,
                width: 40.w,
                height: 40.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.font12GreyRegular(context).copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
