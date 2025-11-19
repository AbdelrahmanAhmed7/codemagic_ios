import 'dart:async';
import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class HealthTipModel {
  final String title;
  final String description;
  final String image;
  final Color backgroundColor;

  HealthTipModel({
    required this.title,
    required this.description,
    required this.image,
    required this.backgroundColor,
  });
}

class HealthTipsWidget extends StatefulWidget {
  const HealthTipsWidget({super.key});

  @override
  State<HealthTipsWidget> createState() => _HealthTipsWidgetState();
}

class _HealthTipsWidgetState extends State<HealthTipsWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<HealthTipModel> _tips = [
    HealthTipModel(
      title: 'home.health_tips_title',
      description: 'home.health_tips_description',
      image: AppAssets.checkUp,
      backgroundColor: const Color(0xffCBDCF9),
    ),
    HealthTipModel(
      title: 'home.health_tips_hydration_title',
      description: 'home.health_tips_hydration_desc',
      image: AppAssets.medicine,
      backgroundColor: const Color(0xffE2F6CA),
    ),
    HealthTipModel(
      title: 'home.health_tips_exercise_title',
      description: 'home.health_tips_exercise_desc',
      image: AppAssets.stethoscope,
      backgroundColor: const Color(0xffF9CBDC),
    ),
    HealthTipModel(
      title: 'home.health_tips_sleep_title',
      description: 'home.health_tips_sleep_desc',
      image: AppAssets.family,
      backgroundColor: const Color(0xffF9EBCB),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) return;
      if (_currentPage < _tips.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'home.health_tips'.tr(),
          style: AppTextStyles.font16BlackMedium(context).copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 180.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _tips.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final tip = _tips[index];
              // Check if title/desc are keys or raw strings
              String title = tip.title.startsWith('home.') ? tip.title.tr() : tip.title;
              String desc = tip.description.startsWith('home.') ? tip.description.tr() : tip.description;

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: tip.backgroundColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  textDirection: isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: isArabic ? 0 : 12.w,
                          left: isArabic ? 12.w : 0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              style: AppTextStyles.font14BlackMedium(context).copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              desc,
                              style: AppTextStyles.font14GreyRegular(context).copyWith(
                                height: 1.3,
                                fontSize: 12.sp,
                              ),
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.asset(
                        tip.image,
                        width: 110.w,
                        height: 110.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16.h),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(_tips.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _currentPage == index ? 24.w : 8.w,
                height: 8.h,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? AppColors.primaryClr
                      : AppColors.greyClr.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
