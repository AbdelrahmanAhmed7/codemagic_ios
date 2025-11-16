import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/home/data/home_response_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mediconsult/core/services/notification_badge_service.dart';

class HomeHeaderWidget extends StatelessWidget {
  final HomeData data;

  const HomeHeaderWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Wrap in RepaintBoundary for better scroll performance
    return RepaintBoundary(
      child: Container(
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
                // Container(
                //   width: 48.w,
                //   height: 48.h,
                //   decoration: const BoxDecoration(
                //     shape: BoxShape.circle,
                //   ),
                //   clipBehavior: Clip.antiAlias,
                //   child: data.memberPhoto != null && data.memberPhoto!.isNotEmpty
                //       ? CachedNetworkImage(
                //           imageUrl: data.memberPhoto!,
                //           fit: BoxFit.cover,
                //           memCacheWidth: 96,
                //           memCacheHeight: 96,
                //           maxWidthDiskCache: 96,
                //           maxHeightDiskCache: 96,
                //           placeholder: (context, url) => const ImageShimmer.circle(),
                //           errorWidget: (context, url, error) => Image.asset(
                //             AppAssets.logo,
                //             fit: BoxFit.cover,
                //           ),
                //         )
                //       : Image.asset(AppAssets.logo, fit: BoxFit.cover),
                // ),
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
              context.push('/notifications');
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
                  child: Icon(
                    CupertinoIcons.bell,
                    size: 22.w,
                    color: AppColors.blackClr,
                  ),
                ),
                Positioned(
                  top: -2.h,
                  right: -2.w,
                  child: ValueListenableBuilder<int>(
                    valueListenable: NotificationBadgeService.instance.unreadCount,
                    builder: (context, count, _) {
                      final badge = count > 0 ? count : data.notificationsCount;
                      if (badge <= 0) return const SizedBox.shrink();
                      return Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
