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
          'Explore',
          style: AppTextStyles.font14BlackMedium,
        ),
        SizedBox(height: 16.h),

        // Explore Items
        _buildExploreItem(
          title: 'Providers',
          description: 'Find healthcare networks, hospitals and Pharmacies',
          iconPath: AppAssets.providers,
          arrowPath: 'assets/icons/arrow.png',
          onTap: () {},
        ),
        SizedBox(height: 12.h),
        _buildExploreItem(
          title: 'Policy',
          description: 'View & manage insurance policies',
          iconPath: AppAssets.policy,
          arrowPath: 'assets/icons/arrow.png',
          onTap: () {},
        ),
        SizedBox(height: 12.h),
        _buildExploreItem(
          title: 'Family',
          description: 'Add & manage family members',
          iconPath: AppAssets.family,
          arrowPath: 'assets/icons/arrow.png',
          onTap: () {
            context.go('/family-members');
          },
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
  }) {
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
                  Text(
                    title,
                    style: AppTextStyles.font14BlackMedium,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: AppTextStyles.font12GreyRegular,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Arrow Image (15×16)
            Image.asset(
              AppAssets.arrowRight,
              width: 25.w,
              height: 20.h,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
