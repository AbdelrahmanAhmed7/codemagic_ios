import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class KhusmPromotionWidget extends StatelessWidget {
  const KhusmPromotionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteClr,
        borderRadius: BorderRadius.circular(16.r),
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
          // Left Side - Logo and Text
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Khusm Logo 
                Image.asset(
                  AppAssets.khusmLogo,
                  width: 133.w,
                  height: 32.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 16.h),

                Text(
                  'Save up to 30% on Medications & Lab Tests...etc!',
                  style: AppTextStyles.font14BlackMedium.copyWith(
                    fontSize: 12.sp,
                    color: Color(0xff484848),
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 20.h),

                // Download App Button
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(0xff4F8787),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Download app',
                    style: AppTextStyles.font12GreyRegular.copyWith(
                      color: AppColors.whiteClr,
                      fontWeight: FontWeight.w400,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // Right Side - Phone image فقط بدون container رمادي
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Image.asset(
                AppAssets.mobile,
                width: 100.w,
                height: 130.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
