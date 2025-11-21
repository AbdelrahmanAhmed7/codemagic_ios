import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/policy/data/policy_models.dart';

class ServiceCard extends StatelessWidget {
  final PolicyService service;

  const ServiceCard({super.key, required this.service});

  Color _getColor() {
    return Color(int.parse('0xFF${service.color}'));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(service.route);
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: _getColor(),
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
                service.icon,
                style: TextStyle(fontSize: 24.sp),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              service.name,
              style: AppTextStyles.font12BlackMedium(context),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
