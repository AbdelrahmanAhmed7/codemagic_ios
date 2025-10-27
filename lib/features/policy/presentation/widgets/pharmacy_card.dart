import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/policy/data/policy_models.dart';

class PharmacyCard extends StatelessWidget {
  final PolicyProvider provider;

  const PharmacyCard({super.key, required this.provider});

  Color _getCopaymentColor() {
    if (provider.copaymentPercentage == '10%') {
      return const Color(0xFF4CAF50);
    } else if (provider.copaymentPercentage == '15%') {
      return const Color(0xFFFF9800);
    } else {
      return const Color(0xFFF44336);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteClr,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFECECEC)),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                provider.logo,
                style: TextStyle(fontSize: 24.sp),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.name,
                  style: AppTextStyles.font14BlackMedium,
                ),
                SizedBox(height: 4.h),
                Text(
                  provider.copaymentType,
                  style: AppTextStyles.font12GreyRegular,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                provider.copaymentPercentage,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: _getCopaymentColor(),
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to provider details
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'View Details',
                  style: AppTextStyles.font12BlueRegular,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
