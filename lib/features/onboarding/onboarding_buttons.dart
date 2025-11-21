import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class OnboardingButtons extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final bool isLastPage;
  final Future<void> Function() onFinish;

  const OnboardingButtons({
    super.key,
    required this.pageController,
    required this.currentPage,
    required this.isLastPage,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final isFirstPage = currentPage == 0;

    final arrowButton = Container(
      height: 56.h,
      width: 56.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        style: IconButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          splashFactory: NoSplash.splashFactory,
          overlayColor: Colors.transparent,
        ),
        icon: Icon(
          isArabic
              ? Icons.arrow_forward_outlined
              : Icons.arrow_back_outlined,
          color: Colors.blue,
        ),
        onPressed: () {
          pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        },
      ),
    );

    final mainButton = SizedBox(
      width: isFirstPage ? 300.w : 245.w,
      height: 56.h,
      child: ElevatedButton(
        onPressed: () {
          if (isLastPage) {
            onFinish();
          } else {
            pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        child: Ink(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E66F5), Color(0xFF274F9C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              isLastPage ? tr('common.get_started') : tr('common.next'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    final children = <Widget>[
      if (!isFirstPage && !isArabic) arrowButton,
      if (!isFirstPage && !isArabic) SizedBox(width: 16.w),
      mainButton,
      if (!isFirstPage && isArabic) SizedBox(width: 16.w),
      if (!isFirstPage && isArabic) arrowButton,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
