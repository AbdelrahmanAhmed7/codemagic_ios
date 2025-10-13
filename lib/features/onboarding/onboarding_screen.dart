import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/onboarding/onboarding_model';
import 'onboarding_page.dart';

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
      title: 'Your Insurance, In Your Pocket',
      description: 'Search for providers in your network',
    ),
    OnboardingModel(
      image: 'assets/onboarding/3.png',
      title: 'Find Hospitals & Pharmacies',
      description: 'View list of your network providers\n near your location',
    ),
    OnboardingModel(
      image: 'assets/onboarding/4.png',
      title: 'Pre-approvals',
      description: 'View status of requests pending\n approval',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _finish() {
    context.go('/signup');
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _pages.length;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20.h,),
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(onPressed: _finish, child: Text("Skip",style: TextStyle(
                  fontSize: 16.sp,
                  color: Color(0xff090F47),
                  fontFamily: 'Roboto'
                ),)),
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
                                  TextSpan(text: 'Welcome to ',style: AppTextStyles.font20BlackSemiBold),
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
                              'Get access to a wide network of\n hospitals, clinic, pharmacies and labs',
                              style: AppTextStyles.font16GreyRegular,
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
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    if (_currentPage != 0)
                      GestureDetector(
                        onTap: (){
                            _controller.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                        },
                          child: Image.asset(AppAssets.backward,width: 20.w,height: 20.h,))
                    else
                      const SizedBox(width: 48),
                    const Spacer(),
                    GestureDetector(
                      onTap: _nextPage,
                      child: Container(
                        width: 245.w,
                        height: 56.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4285F4), Color(0xFF0139FE)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          isLast ? "Get Started" : "Next",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
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
