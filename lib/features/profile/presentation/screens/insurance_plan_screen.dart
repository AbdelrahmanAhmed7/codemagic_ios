import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';

class InsurancePlanScreen extends StatelessWidget {
  const InsurancePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyClr,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(title: 'insurance_plan.title'.tr(), backPath: '/profile'),
            Expanded(
              child: Transform.translate(
                offset: Offset(0, -20.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteClr,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.greyClr.withValues(alpha: 0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInsuranceCard(context),
                          SizedBox(height: 32.h),
                          _buildCoverageDetails(context),
                          SizedBox(height: 24.h),
                          _buildCoverageMembers(context),
                          SizedBox(height: 8.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsuranceCard(context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4285F4), Color(0xFFF2C416)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyClr.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'insurance_plan.gold_health_plan'.tr(),
                        style: AppTextStyles.font20WhiteSemiBold(context),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'insurance_plan.policy_number'.tr(),
                        style: AppTextStyles.font14WhiteRegular(context),
                      ),
                    ],
                  ),
                ),
                Image.asset(AppAssets.jewelry, height: 24.h, width: 24.w),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'insurance_plan.valid_until'.tr(),
                      style: AppTextStyles.font14WhiteRegular(context),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'insurance_plan.valid_date'.tr(),
                      style: AppTextStyles.font16WhiteRegular(context).copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('insurance_plan.status'.tr(), style: AppTextStyles.font14GreenRegular(context)),
                    SizedBox(height: 4.h),
                    Text('insurance_plan.active'.tr(), style: AppTextStyles.font16GreenMedium(context)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverageDetails(context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteClr,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyClr.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('insurance_plan.coverage_details'.tr(), style: AppTextStyles.font14BlackMedium(context)),
            SizedBox(height: 16.h),
            _buildCoverageItem('insurance_plan.coverage_type'.tr(), 'insurance_plan.family_plan'.tr(),context),
            _buildCoverageItem('insurance_plan.annual_limit'.tr(), 'EGP 300,000',context),
            _buildCoverageItem('insurance_plan.deductible'.tr(), 'EGP 1,000',context),
            _buildCoverageItem('insurance_plan.copayment'.tr(), '20%',context),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverageItem(String title, String value,context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.font12GreyRegular(context)),
          Text(
            value,
            style: AppTextStyles.font12BlueMedium(context).copyWith(
              color: AppColors.blueClrW,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverageMembers(context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteClr,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyClr.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('insurance_plan.coverage_member'.tr(), style: AppTextStyles.font14BlackMedium(context)),
            SizedBox(height: 16.h),
            _buildMemberItem(
              'Ahmed Mohamed Adel Amin',
              'insurance_plan.main_member'.tr(),
              'assets/approval/ahmed.png',
              context
            ),
            Divider(color: AppColors.lightGreyClr),
            _buildMemberItem(
              'Noha Khaled Ali Mohamed',
              'insurance_plan.spouse'.tr(),
              'assets/approval/noha.png',
              context
            ),
            Divider(color: AppColors.lightGreyClr),
            _buildMemberItem(
              'Youssef Ahmed Mohamed',
              'insurance_plan.son'.tr(),
              'assets/approval/ali.png',
              context
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberItem(String name, String role, String imagePath,context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          CircleAvatar(radius: 20.r, backgroundImage: AssetImage(imagePath)),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.font12BlackMedium(context)),
                Text(role, style: AppTextStyles.font10GreyRegular(context).copyWith(
                  color: Color(0xff484848),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
