import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class RefundEmptyState extends StatelessWidget {
  const RefundEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 50.h),
          Image.asset(AppAssets.refundEmpty, width: 250.w, height: 200.h),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                Text(
                  'refund_history.empty_state_title'.tr(),
                  style: AppTextStyles.font20BlackSemiBold(context),
                ),
                SizedBox(height: 8.h),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTextStyles.font14BlackMedium(context).copyWith(
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(text: 'refund_history.empty_state'.tr()),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF2563EB),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      TextSpan(text: 'refund_history.to_request_refund'.tr()),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..scale(context.locale.languageCode == 'ar' ? -1.0 : 1.0, 1.0),
            child: Image.asset(AppAssets.arrow, width: 130.w, height: 130.h),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
