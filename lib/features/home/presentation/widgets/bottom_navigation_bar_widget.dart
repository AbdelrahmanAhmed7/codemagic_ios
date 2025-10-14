import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:mediconsult/core/theming/app_colors.dart';

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
    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteClr,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyClr.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: AnimatedBottomNavigationBar(
        icons: const [
          Icons.home,
          Icons.business,
          Icons.description,
          Icons.person,
        ],
        activeIndex: currentIndex,
        gapLocation: GapLocation.center,
        leftCornerRadius: 20.r,
        rightCornerRadius: 20.r,
        onTap: onTap,
        backgroundColor: AppColors.whiteClr,
        activeColor: AppColors.primaryClr,
        inactiveColor: AppColors.greyClr,
        iconSize: 24.sp,
        elevation: 0,
        notchMargin: 8.w,
        splashColor: AppColors.primaryClr.withValues(alpha: 0.1),
        splashRadius: 30.r,
      ),
    );
  }
}
