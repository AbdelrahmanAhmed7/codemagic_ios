import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/home/presentation/home_screen.dart';

class UserPlanCardWidget extends StatelessWidget {
  final PlanType planType;
  final String userName;
  final String cardId;
  final String expireDate;
  final String? profileImage;

  const UserPlanCardWidget({
    super.key,
    required this.planType,
    required this.userName,
    required this.cardId,
    required this.expireDate,
    this.profileImage,
  });

  Color get planColor {
    switch (planType) {
      case PlanType.gold:
        return AppColors.goldPlanColor;
      case PlanType.silver:
        return AppColors.silverPlanColor;
      case PlanType.bronze:
        return AppColors.bronzePlanColor;
      case PlanType.platinum:
        return AppColors.platinumPlanColor;
      case PlanType.diamond:
        return AppColors.diamondPlanColor;
    }
  }

  String get planName {
    switch (planType) {
      case PlanType.gold:
        return 'Gold Plan';
      case PlanType.silver:
        return 'Silver Plan';
      case PlanType.bronze:
        return 'Bronze Plan';
      case PlanType.platinum:
        return 'Platinum Plan';
      case PlanType.diamond:
        return 'Diamond Plan';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200.h,
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
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
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Plan type card
          Positioned(
            top: -16.h,
            left: -16.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: planColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  bottomRight: Radius.circular(12.r),
                ),
              ),
              child: Text(
                planName,
                style: AppTextStyles.font12GreyRegular.copyWith(
                  color: AppColors.blackClr,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // User Info
          Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: Row(
              children: [
                Container(
                  width: 86.w,
                  height: 104.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.lightGreyClr,
                    image: profileImage != null
                        ? DecorationImage(
                            image: AssetImage(AppAssets.card),
                            fit: BoxFit.cover,
                          )
                        : const DecorationImage(
                            image: AssetImage(AppAssets.profile),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(width: 18.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 18.h),
                      Text(
                        userName,
                        style: AppTextStyles.font14BlackMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Text(
                            'Card ID',
                            style: AppTextStyles.font14GreyRegular.copyWith(
                              color: const Color(0xff484848),
                            ),
                          ),
                          SizedBox(width: 30.w),
                          Text(
                            cardId,
                            style: AppTextStyles.font14GreyRegular.copyWith(
                              color: const Color(0xff484848),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Text(
                            'Expire Date',
                            style: AppTextStyles.font14GreyRegular.copyWith(
                              color: const Color(0xff484848),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            expireDate,
                            style: AppTextStyles.font14GreyRegular.copyWith(
                              color: const Color(0xff484848),
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // QR Code image at bottom right
          Positioned(
            bottom: 8.h,
            right: 8.w,
            child: Image.asset(
              AppAssets.qrCode,
              width: 42.w,
              height: 52.h,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
