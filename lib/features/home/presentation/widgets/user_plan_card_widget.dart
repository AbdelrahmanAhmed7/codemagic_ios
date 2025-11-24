import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/home/data/home_response_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mediconsult/core/widgets/image_shimmer.dart';

class UserPlanCardWidget extends StatelessWidget {
  final HomeData data;

  const UserPlanCardWidget({super.key, required this.data});

  Color get planColor {
    if (data.programColor.isNotEmpty) {
      try {
        String colorHex = data.programColor.replaceAll('#', '');
        if (colorHex.length == 6) {
          colorHex = 'FF$colorHex';
        }
        return Color(int.parse(colorHex, radix: 16));
      } catch (e) {
        return AppColors.goldPlanColor;
      }
    }
    return AppColors.goldPlanColor;
  }

  String get planName {
    if (data.programName.isNotEmpty) return data.programName;
    return 'Gold Plan';
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final formattedDate =
        (data.policyExpireDate.isNotEmpty &&
            data.policyExpireDate.contains('T'))
        ? data.policyExpireDate.split('T').first
        : data.policyExpireDate;
    // Wrap in RepaintBoundary for better scroll performance
    return RepaintBoundary(
      child: Container(
        width: double.infinity,
        height: 200.h,
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
        decoration: BoxDecoration(
          color: AppColors.whiteClr,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.greyClr.withValues(alpha: 0.10),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Plan type label
            Positioned(
              top: -16.h,
              left: isArabic ? null : -16.w,
              right: isArabic ? -16.w : null,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: planColor,
                  borderRadius: isArabic
                      ? BorderRadius.only(
                          topRight: Radius.circular(12.r),
                          bottomLeft: Radius.circular(16.r),
                        )
                      : BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          bottomRight: Radius.circular(12.r),
                        ),
                ),
                child: Text(
                  planName,
                  style: AppTextStyles.font12GreyRegular(context).copyWith(
                    color: AppColors.whiteClr,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // User Info
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Row(
                children: [
                  Container(
                    width: 86.w,
                    height: 104.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.lightGreyClr,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: data.memberPhoto != null && data.memberPhoto!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: data.memberPhoto!,
                            fit: BoxFit.cover,
                            memCacheWidth: 172,
                            memCacheHeight: 208,
                            maxWidthDiskCache: 172,
                            maxHeightDiskCache: 208,
                            placeholder: (context, url) => const ImageShimmer.circle(),
                            errorWidget: (context, url, error) => Image.asset(
                              AppAssets.logo,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(AppAssets.logo, fit: BoxFit.cover),
                  ),
                  SizedBox(width: 18.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 18.h),
                        Text(
                          data.memberName,
                          style: AppTextStyles.font14BlackMedium(context),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Text(
                              'home.member_id'.tr(),
                              style: AppTextStyles.font14GreyRegular(
                                context,
                              ).copyWith(color: const Color(0xff484848)),
                            ),
                            SizedBox(width: 20.w),
                            Text(
                              data.memberId.toString(),
                              style: AppTextStyles.font14GreyRegular(
                                context,
                              ).copyWith(color: const Color(0xff484848)),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Text(
                              'home.expire_date'.tr(),
                              style: AppTextStyles.font14GreyRegular(
                                context,
                              ).copyWith(color: const Color(0xff484848)),
                            ),
                            SizedBox(width: 18.w),
                            Text(
                              formattedDate,
                              style: AppTextStyles.font14GreyRegular(
                                context,
                              ).copyWith(color: const Color(0xff484848)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // QR Code at bottom right
            // Positioned(
            //   bottom: 8.h,
            //   right: isArabic ? null : 8.w,
            //   left: isArabic ? 8.w : null,
            //   child: Image.asset(
            //     AppAssets.qrCode,
            //     width: 42.w,
            //     height: 52.h,
            //     fit: BoxFit.contain,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
