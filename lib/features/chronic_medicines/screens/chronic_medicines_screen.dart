import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/utils/app_button.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/family_members_selector.dart';
import 'package:mediconsult/features/chronic_medicines/widgets/action_required_dialog.dart';
import 'package:mediconsult/features/chronic_medicines/widgets/lab_results_upload.dart';
import 'package:mediconsult/features/chronic_medicines/widgets/month_header.dart';
import 'package:mediconsult/features/chronic_medicines/widgets/monthly_medicines_selector.dart';
import 'package:mediconsult/features/chronic_medicines/widgets/upcoming_lab_card.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:mediconsult/shared/widgets/custom_showcase.dart';
// ignore_for_file: deprecated_member_use

class ChronicMedicinesScreen extends StatefulWidget {
  const ChronicMedicinesScreen({super.key});

  @override
  State<ChronicMedicinesScreen> createState() => _ChronicMedicinesScreenState();
}

class _ChronicMedicinesScreenState extends State<ChronicMedicinesScreen> {
  final GlobalKey<LabResultsUploadState> _labKey = GlobalKey();
  final GlobalKey _familyKey = GlobalKey();
  final GlobalKey _saveKey = GlobalKey();
  
  // Showcase state
  int _showcaseIndex = -1;

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('chronic_medicines.saved'.tr())));
    }
  }

  void _startShowcase() {
    setState(() {
      _showcaseIndex = 0;
    });
  }

  void _nextShowcase() {
    if (_showcaseIndex < _showcaseKeys.length - 1) {
      setState(() {
        _showcaseIndex++;
      });
    } else {
      _dismissShowcase();
    }
  }

  void _dismissShowcase() {
    setState(() {
      _showcaseIndex = -1;
    });
  }

  List<GlobalKey> get _showcaseKeys => [
        _familyKey,
        _saveKey,
      ];

  List<String> get _showcaseDescriptions => [
        'tutorial.family_members.select'.tr(),
        'tutorial.save.tap'.tr(),
      ];

  @override
  Widget build(BuildContext context) {
    return CustomShowcaseOverlay(
      targetKeys: _showcaseKeys,
      descriptions: _showcaseDescriptions,
      currentIndex: _showcaseIndex,
      onNext: _nextShowcase,
      onDismiss: _dismissShowcase,
      child: Scaffold(
        backgroundColor: AppColors.lightGreyClr,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageHeader(
                  title: 'chronic_medicines.title'.tr(),
                  backPath: '/home',
                  onHelp: () {
                    _startShowcase();
                  },
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
                                Image.asset(
                                  AppAssets.familySelect,
                                  width: 16.w,
                                  height: 16.h,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'chronic_medicines.select_member'.tr(),
                                  style: AppTextStyles.font14BlackMedium(
                                    context,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            CustomShowcase(
                              key: _familyKey,
                              targetKey: _familyKey,
                              child: const FamilyMembersSelector(),
                            ),
                            SizedBox(height: 24.h),
                            Row(
                              children: [
                                Image.asset(
                                  AppAssets.mdeiSelector,
                                  width: 16.w,
                                  height: 16.h,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'chronic_medicines.select_medicines'.tr(),
                                  style: AppTextStyles.font14BlackMedium(
                                    context,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            const MonthlyMedicinesSelector(),
                            SizedBox(height: 36.h),
                            const UpcomingLabCard(),
                            SizedBox(height: 16.h),
                            Text(
                              'chronic_medicines.upload_lab_results'.tr(),
                              style: AppTextStyles.font14BlackMedium(context),
                            ),
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
                                  Text(
                                    'chronic_medicines.required_tests'.tr(),
                                    style: AppTextStyles.font16BlueMedium(
                                      context,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Row(
                                    children: [
                                      Image.asset(
                                        AppAssets.tests,
                                        width: 16.w,
                                        height: 16.h,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'chronic_medicines.blood_sugar_test'
                                            .tr(),
                                        style: AppTextStyles.font12GreyRegular(
                                          context,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        AppAssets.tests,
                                        width: 16.w,
                                        height: 16.h,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'chronic_medicines.kidney_function_test'
                                            .tr(),
                                        style: AppTextStyles.font12GreyRegular(
                                          context,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 24.h),
                                  LabResultsUpload(key: _labKey),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                            CustomShowcase(
                              key: _saveKey,
                              targetKey: _saveKey,
                              child: SizedBox(
                                width: double.infinity,
                                height: 48.h,
                                child: AppButton(
                                  text: 'common.save'.tr(),
                                  onPressed: _onSave,
                                ),
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
      ),
    );
  }
}
