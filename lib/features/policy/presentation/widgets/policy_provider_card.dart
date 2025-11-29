import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/policy/data/policy_details_response.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:easy_localization/easy_localization.dart';

class PolicyProviderCard extends StatelessWidget {
  final PolicyProviderItem provider;
  final VoidCallback? onTap;

  const PolicyProviderCard({super.key, required this.provider, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProviderLogo(),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        provider.providerName,
                        style: AppTextStyles.font14BlackMedium(
                          context,
                        ).copyWith(height: 1.3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _getCopaymentLabel(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${provider.copaymentPercent.toInt()}%',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: _getCopaymentColor(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    final copayment = provider.copaymentPercent.toInt();
    if (copayment >= 20) {
      return const Color(0xFFFFF0F0);
    } else if (copayment >= 15) {
      return const Color(0xFFFFF8E1);
    } else {
      return const Color(0xFFF5F9FF);
    }
  }

  String _getCopaymentLabel() {
    final copayment = provider.copaymentPercent.toInt();
    if (copayment >= 20) {
      return 'policy_screen.highest_copayment'.tr();
    } else if (copayment >= 15) {
      return 'policy_screen.higher_copayment'.tr();
    } else {
      return 'policy_screen.standard_copayment'.tr();
    }
  }

  Color _getCopaymentColor() {
    final copayment = provider.copaymentPercent.toInt();
    if (copayment >= 20) {
      return const Color(0xFFE53935);
    } else if (copayment >= 15) {
      return const Color(0xFFFF9800);
    } else {
      return const Color(0xFF2196F3);
    }
  }

  Widget _buildProviderLogo() {
    // Check if logo is empty or null
    final hasLogo = provider.logo.isNotEmpty;

    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.all(4.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.r),
        child: hasLogo
            ? CachedNetworkImage(
                imageUrl: provider.logo,
                fit: BoxFit.contain,
                placeholder: (context, url) => Container(
                  color: Colors.grey[100],
                  child: Center(
                    child: SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryClr,
                        ),
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) =>
                    Image.asset(AppAssets.logo, fit: BoxFit.contain),
              )
            : Image.asset(AppAssets.logo, fit: BoxFit.contain),
      ),
    );
  }
}
