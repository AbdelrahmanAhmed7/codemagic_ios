import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

import 'package:mediconsult/features/home/data/home_response_model.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeHeaderWidget extends StatelessWidget {
  final HomeData data;

  const HomeHeaderWidget({super.key, required this.data});

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
                    image: DecorationImage(
                      image: (data.memberPhoto != null && data.memberPhoto!.isNotEmpty)
                          ? AssetImage(data.memberPhoto!)
                          : const AssetImage(AppAssets.logo) as ImageProvider,
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
                        '${'home.hello'.tr()}${data.memberName.split(" ").first}',
                        style: AppTextStyles.font16WhiteRegular(context).copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'home.health_question'.tr(),
                        style: AppTextStyles.font10WhiteRegular(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Notification Icon with Badge
          InkWell(
            onTap: (){
              context.go('/notifications');
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 30.w,
                  height: 30.h,
                  decoration: const BoxDecoration(
                    color: AppColors.whiteClr,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    AppAssets.notification,
                    width: 15.w,
                    height: 15.h,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                if (data.notificationsCount > 0)
                  Positioned(
                    top: -2.h,
                    right: -2.w,
                    child: Container(
                      width: 14.w,
                      height: 14.w,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        data.notificationsCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
