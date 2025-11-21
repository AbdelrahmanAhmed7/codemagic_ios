import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/policy/data/policy_details_response.dart';

class PolicyProviderCard extends StatelessWidget {
  final PolicyProviderItem provider;

  const PolicyProviderCard({super.key, required this.provider});

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
          _buildProviderLogo(),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.providerName,
                  style: AppTextStyles.font14BlackMedium(context),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Copayment: ${provider.copaymentPercent}%',
                  style: AppTextStyles.font12GreyRegular(context),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Future: call provider details by providerId and navigate
            },
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderLogo() {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A8A),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: Image.network(
            provider.logo,
            width: 48.w,
            height: 48.w,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Icon(
              Icons.local_hospital,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
        ),
      ),
    );
  }
}
