import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';

class AppTextStyles {
  static final TextStyle font20BlackSemiBold = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.blackClr,
    fontFamily: 'Roboto',
  );
  static final TextStyle font16GreyRegular = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.greyClr,
    fontFamily: 'Roboto',
  );
  static final TextStyle font14GreyRegular = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.greyClr,
    fontFamily: 'Roboto',
  );
  static final TextStyle font14BlackMedium = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.blackClr,
    fontFamily: 'Roboto',
  );
  static final TextStyle font16BlackMedium = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.blackClr,
    fontFamily: 'Roboto',
  );
}
