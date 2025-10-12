import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class AccountVerifiedScreen extends StatefulWidget {
  const AccountVerifiedScreen({super.key});

  @override
  State<AccountVerifiedScreen> createState() => _AccountVerifiedScreenState();
}

class _AccountVerifiedScreenState extends State<AccountVerifiedScreen> {
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
              SizedBox(height: 4.h),
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
                      style: AppTextStyles.font16BlackMedium,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Congratulations, your account has been\n verified. You can start using the app',
                      style: AppTextStyles.font14GreyRegular,
                      textAlign: TextAlign.center,
                    ),
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
