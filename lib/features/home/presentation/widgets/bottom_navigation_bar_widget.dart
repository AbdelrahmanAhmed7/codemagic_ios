import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 32.w;
    final isRtl = Directionality.of(context) == ui.TextDirection.rtl;
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
      child: SizedBox(
        height: 80.h,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 65.h,
              decoration: BoxDecoration(
                color: AppColors.whiteClr,
                borderRadius: BorderRadius.circular(40.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Directionality(
                textDirection: isRtl
                    ? ui.TextDirection.rtl
                    : ui.TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(4, (index) {
                    return _buildNavItem(index);
                  }),
                ),
              ),
            ),

            Positioned(
              top: -25.h,
              left: isRtl
                  ? null
                  : (currentIndex * (screenWidth / 4)) +
                        (screenWidth / 8) -
                        25.w,
              right: isRtl
                  ? (currentIndex * (screenWidth / 4)) +
                        (screenWidth / 8) -
                        25.w
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  color: AppColors.whiteClr,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryClr.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(10.w),
                child: Image.asset(
                  _getIconPath(currentIndex, true),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.translucent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10.h),
          Image.asset(
            _getIconPath(index, false),
            width: 22.w,
            height: 22.h,
            color: isSelected ? Colors.transparent : AppColors.greyClr,
          ),
          SizedBox(height: 4.h),
          Text(
            _getLabel(index),
            style: TextStyle(
              fontSize: 11.sp,
              color: isSelected ? AppColors.primaryClr : AppColors.greyClr,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return 'bottom_nav.home'.tr();
      case 1:
        return 'bottom_nav.provider'.tr();
      case 2:
        return 'bottom_nav.request'.tr();
      case 3:
        return 'bottom_nav.profile'.tr();
      default:
        return '';
    }
  }

  String _getIconPath(int index, bool isActive) {
    switch (index) {
      case 0:
        return isActive ? AppAssets.homeActive : AppAssets.homeInactive;
      case 1:
        return isActive ? AppAssets.providerActive : AppAssets.providerInactive;
      case 2:
        return isActive ? AppAssets.requestActive : AppAssets.requestInactive;
      case 3:
        return isActive ? AppAssets.profileActive : AppAssets.profileInactive;
      default:
        return '';
    }
  }
}
