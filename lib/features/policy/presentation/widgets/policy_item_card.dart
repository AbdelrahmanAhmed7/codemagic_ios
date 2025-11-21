import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/policy/data/policy_models.dart';

class PolicyItemCard extends StatelessWidget {
  final PolicyItem item;
  final VoidCallback? onTap;

  const PolicyItemCard({
    super.key, 
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Service card style
    if (item.type == PolicyItemType.service) {
      return GestureDetector(
        onTap: onTap ?? () {
          if (item.route != null) {
            context.push(item.route!);
          }
        },
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: item.color != null ? Color(int.parse('0xFF${item.color}')) : AppColors.primaryClr,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.whiteClr,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  item.icon ?? '📋',
                  style: TextStyle(fontSize: 24.sp),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                item.name,
                style: AppTextStyles.font12BlackMedium(context).copyWith(
                  color: AppColors.whiteClr,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    } 
    // Provider card style
    else {
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
                  item.icon ?? '🏥',
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
                    item.name,
                    style: AppTextStyles.font14BlackMedium(context),
                  ),
                  if (item.description != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      item.description!,
                      style: AppTextStyles.font12GreyRegular(context),
                    ),
                  ],
                ],
              ),
            ),
            if (item.additionalInfo != null) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getCopaymentColor(item.additionalInfo!),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  item.additionalInfo!,
                  style: AppTextStyles.font14WhiteMedium(context),
                ),
              ),
            ],
          ],
        ),
      );
    }
  }

  Color _getCopaymentColor(String value) {
    if (value.contains('10%')) {
      return const Color(0xFF4CAF50);
    } else if (value.contains('15%')) {
      return const Color(0xFFFF9800);
    } else {
      return const Color(0xFFF44336);
    }
  }
}