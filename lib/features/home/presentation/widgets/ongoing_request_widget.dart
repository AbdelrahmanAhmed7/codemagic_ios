import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/constants/app_assets.dart'; // لازم يكون فيه مسارات الصور

class OngoingRequestWidget extends StatelessWidget {
  const OngoingRequestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with See All
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ongoing Request', style: AppTextStyles.font14BlackMedium),
            GestureDetector(
              onTap: () {},
              child: Text(
                'See All',
                style: AppTextStyles.font14PrimaryMedium.copyWith(
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        // Request Card
        Container(
          width: double.infinity,
          height: 90.h,
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
            children: [
              // 🟧 Yellow Side Bar
              Container(
                width: 6.w,
                height: 90.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC888),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    bottomLeft: Radius.circular(12.r),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  child: Stack(
                    children: [
                      // محتوى الكارد الأساسي
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 🔴 Provider Logo
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.asset(
                              AppAssets.alfaLogo,
                              width: 40.w,
                              height: 40.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 12.w),

                          // النصوص
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Alfa Lab',
                                  style: AppTextStyles.font14BlackMedium,
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Text(
                                      'Service Type: ',
                                      style: AppTextStyles.font12GreyRegular,
                                    ),
                                    Image.asset(
                                      AppAssets.bloodIcon,
                                      width: 20.w,
                                      height: 20.h,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      'Blood Test',
                                      style: AppTextStyles.font12GreyRegular,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Image.asset(
                            AppAssets.arrowRight,
                            width: 15.w,
                            height: 16.h,
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 100.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            color: const Color(
                              0x6BFFC888,
                            ), 
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Under Review',
                            style: AppTextStyles.font10GreyRegular.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Color(0xffC66D04),
                              fontSize: 8.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
