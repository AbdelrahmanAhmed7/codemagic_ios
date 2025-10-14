import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: const BoxDecoration(
        color: AppColors.primaryClr,
      ),
      child: Row(
        children: [
          // Profile Section
          Expanded(
            child: Row(
              children: [
                // Profile Picture
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.whiteClr,
                    image: const DecorationImage(
                      image: AssetImage(AppAssets.profile),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                SizedBox(width: 12.w),
                
                // Greeting Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, Ahmed',
                        style: AppTextStyles.font16WhiteRegular,
                      ),
                      Text(
                        'How is your health now?',
                        style: AppTextStyles.font8WhiteRegular,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Notification Icon
          Container(
            width: 30.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: AppColors.whiteClr,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              AppAssets.notification,
              width: 15.w,
              height: 15.h,
              fit: BoxFit.scaleDown,
            )
          ),
        ],
      ),
    );
  }
}
