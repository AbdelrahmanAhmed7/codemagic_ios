import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/constants/app_assets.dart';

class OngoingRequestWidget extends StatelessWidget {
  const OngoingRequestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Container(
          width: double.infinity,
          height: 120.h,
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
              Container(
                width: 6.w,
                height: 120.h,
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.asset(
                              AppAssets.alfaLogo,
                              width: 48.w,
                              height: 60.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Alfa Lab',
                                  style: AppTextStyles.font14BlackMedium.copyWith(
                                    color: Color(0xff062860),
                                  ),
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
                          SizedBox(height: 22.h),
                          Padding(
                            padding: EdgeInsets.only(right: 16.w, top: 22.h),
                            child: Image.asset(
                              AppAssets.arrowRight,
                              width: 25.w,
                              height: 20.h,
                            ),
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
                            color: const Color(0x6BFFC888),
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