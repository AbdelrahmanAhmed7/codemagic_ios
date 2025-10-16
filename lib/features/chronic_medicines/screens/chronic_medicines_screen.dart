import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/utils/app_button.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/family_members_selector.dart';
import 'package:mediconsult/features/chronic_medicines/widgets/lab_results_upload.dart';
import 'package:mediconsult/features/chronic_medicines/widgets/action_required_dialog.dart';
import 'package:mediconsult/features/chronic_medicines/widgets/month_header.dart';
import 'package:mediconsult/features/chronic_medicines/widgets/monthly_medicines_selector.dart';
import 'package:mediconsult/features/chronic_medicines/widgets/upcoming_lab_card.dart';

class ChronicMedicinesScreen extends StatefulWidget {
  const ChronicMedicinesScreen({super.key});

  @override
  State<ChronicMedicinesScreen> createState() => _ChronicMedicinesScreenState();
}

class _ChronicMedicinesScreenState extends State<ChronicMedicinesScreen> {
  final GlobalKey<LabResultsUploadState> _labKey = GlobalKey();

  Future<void> _onSave() async {
    final isComplete = _labKey.currentState?.isComplete ?? false;
    if (!isComplete && mounted) {
      await showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (context) => const ActionRequiredDialog(),
      );
      return;
    }
    // UI only for now
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyClr,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 136.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryClr,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                  child: Row(
                    children: [
                      Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: AppColors.whiteClr,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.greyClr.withValues(alpha: 0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                          onPressed: () => context.go('/home'),
                        ),
                      ),
                      SizedBox(width: 28.w),
                      Expanded(
                        child: Text(
                          'Chronic Medicines',
                          style: AppTextStyles.font18BlackSemiBold.copyWith(
                            color: AppColors.whiteClr,
                          ),
                        ),
                      ),
                      Container(
                        width: 28.w,
                        height: 28.w,
                        decoration: const BoxDecoration(
                          color: AppColors.whiteClr,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.question,
                          color: AppColors.blackClr,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, -20.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Container(
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
                          MonthHeader(date: DateTime.now()),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Image.asset(AppAssets.familySelect,width: 16.w,height: 16.h,),
                              SizedBox(width: 4.w),
                              Text('Select Member', style: AppTextStyles.font14BlackMedium),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          const FamilyMembersSelector(),
                          SizedBox(height: 24.h),
                          Row(
                            children: [
                              Image.asset(AppAssets.mdeiSelector,width: 16.w,height: 16.h,),
                              SizedBox(width: 4.w),
                              Text('Select Your Monthly Medicines', style: AppTextStyles.font14BlackMedium),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          const MonthlyMedicinesSelector(),
                          SizedBox(height: 36.h),
                          const UpcomingLabCard(),
                          SizedBox(height: 16.h),
                          Text('Upload Quarterly Lab Results', style: AppTextStyles.font14BlackMedium),
                          SizedBox(height: 8.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: AppColors.whiteClr,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Required Tests:', style: AppTextStyles.font16BlueMedium),
                                SizedBox(height: 6.h),
                                Row(
                                  children: [
                                    Image.asset(AppAssets.tests,width: 16.w,height: 16.h,),
                                    SizedBox(width: 4.w),
                                    Text('Blood Sugar Test', style: AppTextStyles.font12GreyRegular),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset(AppAssets.tests,width: 16.w,height: 16.h,),
                                    SizedBox(width: 4.w),
                                    Text('Kidney Function Test', style: AppTextStyles.font12GreyRegular),
                                  ],
                                ),
                                SizedBox(height: 24.h),
                                LabResultsUpload(key: _labKey),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          SizedBox(
                            width: double.infinity,
                            height: 48.h,
                            child: AppButton(
                              text: 'Save',
                              onPressed: _onSave,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}


