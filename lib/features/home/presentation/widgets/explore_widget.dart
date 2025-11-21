import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class ExploreWidget extends StatelessWidget {
  const ExploreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'home.explore'.tr(),
          style: AppTextStyles.font16BlackMedium(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16.h),

        // Explore Items
        _buildExploreItem(
          title: 'explore.providers'.tr(),
          description: 'explore.providers_description'.tr(),
          iconPath: AppAssets.providers,
          arrowPath: 'assets/icons/arrow.png',
          onTap: () {
            context.push('/network');
          },
          context: context,
        ),
        SizedBox(height: 12.h),
        _buildExploreItem(
          title: 'explore.policy'.tr(),
          description: 'explore.policy_description'.tr(),
          iconPath: AppAssets.policy,
          arrowPath: 'assets/icons/arrow.png',
          onTap: () {
            context.push('/policy');
          },
          context: context,
        ),
        SizedBox(height: 12.h),
        _buildExploreItem(
          title: 'explore.family'.tr(),
          description: 'explore.family_description'.tr(),
          iconPath: AppAssets.family,
          arrowPath: 'assets/icons/arrow.png',
          onTap: () {
            context.push('/family-members');
          },
          context: context,
        ),
      ],
    );
  }

  Widget _buildExploreItem({
    required String title,
    required String description,
    required String iconPath,
    required String arrowPath,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    final isArabic = context.locale.languageCode == 'ar';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image icon (بدون خلفية)
            Image.asset(
              iconPath,
              width: 30.w,
              height: 30.h,
              fit: BoxFit.contain,
            ),

            SizedBox(width: 16.w),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.font14BlackMedium(context)),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: AppTextStyles.font12GreyRegular(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Arrow Image (15×16)
            Transform.rotate(
              angle: isArabic ? 3.1416 : 0,
              child: Image.asset(
                AppAssets.arrowRight,
                width: 25.w,
                height: 20.h,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
