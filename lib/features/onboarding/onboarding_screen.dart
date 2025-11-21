import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/constants/constants.dart';
import 'package:mediconsult/core/helpers/shared_pref_helper.dart';
import 'package:mediconsult/features/onboarding/onboarding_buttons.dart';
import 'package:mediconsult/features/onboarding/onboarding_model';
import 'onboarding_page.dart';
import 'package:easy_localization/easy_localization.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<OnboardingModel> _pages = [
    OnboardingModel(
      image: 'assets/onboarding/2.png',
      title: 'onboarding.insurance_in_pocket',
      description: 'onboarding.insurance_description',
    ),
    OnboardingModel(
      image: 'assets/onboarding/3.png',
      title: 'onboarding.find_hospitals',
      description: 'onboarding.find_hospitals_description',
    ),
    OnboardingModel(
      image: 'assets/onboarding/4.png',
      title: 'onboarding.pre_approvals',
      description: 'onboarding.pre_approvals_description',
    ),
  ];

  Future<void> _finish() async {
    await SharedPrefHelper.setData(
      SharedPrefKeys.hasSeenOnboarding,
      true,
    );
    shouldShowOnboarding = false;
    if (!mounted) return;
    if (isLoggedInUser) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = context.locale.languageCode == 'ar';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Align(
                alignment: isRtl ? Alignment.topRight : Alignment.topLeft,
                child: TextButton(
                  onPressed: () {
                    _finish();
                  },
                  child: Text(
                    tr('common.skip'),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xff090F47),
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length + 1,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (_, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/logo/Logo.png',
                              width: 238.w,
                              height: 52.h,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 23.h),
                            Image.asset(
                              'assets/onboarding/1.png',
                              width: 227.w,
                              height: 207.h,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 48.h),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: tr('onboarding.welcome_to'),
                                    style: AppTextStyles.font20BlackSemiBold(
                                      context,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: 'Medi',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  const TextSpan(
                                    text: 'Consult',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              tr('onboarding.welcome_description'),
                              style: AppTextStyles.font16GreyRegular(context),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: OnboardingPage(model: _pages[index - 1]),
                      );
                    }
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length + 1,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 48.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OnboardingButtons(
                    pageController: _controller,
                    currentPage: _currentPage,
                    isLastPage: _currentPage == _pages.length,
                    onFinish: _finish,
                  ),
              ),
              SizedBox(height: 53.h),
              Image.asset(
                'assets/logo/Khusm Logo.png',
                width: 174.w,
                height: 30.h,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}