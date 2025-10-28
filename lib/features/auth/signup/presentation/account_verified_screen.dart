import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/utils/app_button.dart';

class AccountVerifiedScreen extends StatelessWidget {
  const AccountVerifiedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundClr,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(height: 40.h),
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      AppAssets.accountVerified,
                      width: 250.w,
                      height: 263.h,
                    ),
                    SizedBox(height: 38.h),
                    Text(
                      'Account Verified',
                      style: AppTextStyles.font16BlackMedium(context),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Congratulations, your account has been\n verified. You can start using the app',
                      style: AppTextStyles.font14GreyRegular(context),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 57.h,),
                    AppButton(text: 'Continue', onPressed: (){
                      context.go('/home');
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
