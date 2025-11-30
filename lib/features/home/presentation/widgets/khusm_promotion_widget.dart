import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/services/url_launcher_service.dart';
import 'package:easy_localization/easy_localization.dart';

class KhusmPromotionWidget extends StatelessWidget {
  const KhusmPromotionWidget({super.key});

  Future<void> _visitWebsite() async {
    final urlLauncher = UrlLauncherService();
    await urlLauncher.launchURL('https://www.khusm.com');
  }

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
          // Left Side — Logo + Text + Button
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
                  style: AppTextStyles.font14BlackMedium(context).copyWith(
                    fontSize: 12.sp,
                    color: const Color(0xff484848),
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 20.h),

                // Visit Website Button
                GestureDetector(
                  onTap: _visitWebsite,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: const Color(0xff4F8787),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'home.visit_website'.tr(),
                      style: AppTextStyles.font12GreyRegular(context).copyWith(
                        color: AppColors.whiteClr,
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // Right Side — phone + QR + icons stacked
          Expanded(
            flex: 1,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // الموبايل
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    AppAssets.mobile, 
                    width: 100.w,
                    height: 130.h,
                    fit: BoxFit.contain,
                  ),
                ),

                // السماعة (stethoscope)
                Positioned(
                  top: 10.h,
                  left: 5.w,
                  child: Image.asset(
                    AppAssets.stethoscope,
                    width: 35.w,
                    height: 35.h,
                    fit: BoxFit.contain,
                  ),
                ),

                // السرنجة (syringe)
                Positioned(
                  top: -10.h,
                  right: 0.w,
                  child: Image.asset(
                    AppAssets.syringe,
                    width: 35.w,
                    height: 35.h,
                    fit: BoxFit.contain,
                  ),
                ),

                // QR Code
                Positioned(
                  bottom: 12.h,
                  child: Image.asset(
                    AppAssets.qrcode,
                    width: 35.w,
                    height: 35.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}