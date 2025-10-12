import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/onboarding/onboarding_model';

class OnboardingPage extends StatelessWidget {
  final OnboardingModel model;

  const OnboardingPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 68.h),
        Image.asset(
          model.image,
          width: 238.w,
          height: 272.h,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 48.h),
        Text(
          model.title,
          style: AppTextStyles.font20BlackSemiBold,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16.h),
        Text(
          model.description,
          style: AppTextStyles.font16GreyRegular,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
