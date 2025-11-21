import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/network/logic/network_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/features/network/logic/network_state.dart';

class EmptyProvidersState extends StatelessWidget {
  const EmptyProvidersState({super.key});

  @override
  Widget build(BuildContext context) {
    // الحصول على حالة الفلترة من NetworkCubit
    final networkCubit = context.read<NetworkCubit>();
    final isFiltering = networkCubit.state.maybeWhen(
      providersEmpty: () => 
        networkCubit.currentProviderData?.categoryId != null || 
        networkCubit.currentProviderData?.governmentId != null || 
        networkCubit.currentProviderData?.cityId != null,
      orElse: () => false,
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 200.w,
            height: 200.h,
            decoration: BoxDecoration(
              color: AppColors.lightGreyClr,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search,
              size: 80.sp,
              color: AppColors.primaryClr.withValues(alpha: 0.3),
            ),
          ),

          SizedBox(height: 24.h),

          // Title
          Text(
            isFiltering 
                ? 'network.filter_no_results'.tr() // رسالة عند عدم وجود نتائج للفلترة
                : 'network.search_placeholder'.tr(),
            style: AppTextStyles.font16BlackMedium(context),
          ),

          SizedBox(height: 8.h),

          // Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              isFiltering 
                  ? 'network.filter_no_results_description'.tr() // وصف عند عدم وجود نتائج للفلترة
                  : 'network.search_description'.tr(),
              style: AppTextStyles.font14GreyRegular(context),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
