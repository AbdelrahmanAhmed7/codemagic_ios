import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          style: AppTextStyles.font18BlackSemiBold,
        ),
        
        SizedBox(height: 16.h),
        
        // Explore Items
        _buildExploreItem(
          title: 'Providers',
          description: 'Find healthcare networks, hospitals and Pharmacies',
          icon: Icons.business,
          onTap: () {
            // Handle providers tap
          },
        ),
        SizedBox(height: 12.h),
        _buildExploreItem(
          title: 'Policy',
          description: 'View & manage insurance policies',
          icon: Icons.security,
          onTap: () {
            // Handle policy tap
          },
        ),
        SizedBox(height: 12.h),
        _buildExploreItem(
          title: 'Family',
          description: 'Add & manage family members',
          icon: Icons.family_restroom,
          onTap: () {
            // Handle family tap
          },
        ),
      ],
    );
  }

  Widget _buildExploreItem({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColors.primaryClr.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryClr,
                size: 20.sp,
              ),
            ),
            
            SizedBox(width: 16.w),
            
            // Content
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
            
            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.greyClr,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}
