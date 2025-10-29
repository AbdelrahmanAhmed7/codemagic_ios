import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/terms_policy/presentation/widgets/policy_section.dart';
import 'package:mediconsult/features/terms_policy/presentation/widgets/tab_navigation.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';

class TermsPolicyScreen extends StatefulWidget {
  const TermsPolicyScreen({super.key});

  @override
  State<TermsPolicyScreen> createState() => _TermsPolicyScreenState();
}

class _TermsPolicyScreenState extends State<TermsPolicyScreen> {
  bool _isTermsSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyClr,
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'Terms & Privacy Policy', backPath: '/profile'),
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
                    child: Column(
                      children: [
                        // Tab Navigation
                        TabNavigation(
                          isTermsSelected: _isTermsSelected,
                          onTabChanged: (isTerms) {
                            setState(() {
                              _isTermsSelected = isTerms;
                            });
                          },
                        ),
                        
                        // Content
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(16.w),
                            child: _isTermsSelected 
                                ? const TermsContent()
                                : const PrivacyPolicyContent(),
                          ),
                        ),
                      ],
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
}

class TermsContent extends StatelessWidget {
  const TermsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PolicySection(
          title: '1. Introduction',
          content: 'Welcome to Mediconsult medical insurance app. By using our app, you agree to comply with these Terms of Service. If you do not agree, please do not use our services.',
        ),
        
        PolicySection(
          title: '2. Eligibility & Account Registration',
          items: const [
            'You must be 18 years or older to use this app.',
            'You are responsible for keeping your account secure.',
          ],
          useCheckmarks: true,
        ),
        
        PolicySection(
          title: '3. Services',
          items: const [
            'Medical insurance coverage information',
            'Provider search and booking',
            'Claims processing',
            'Customer support',
          ],
        ),
        
        PolicySection(
          title: 'Contact Us',
          email: 'support@mediconsult.com',
          icon: Icons.email,
        ),
      ],
    );
  }
}

class PrivacyPolicyContent extends StatelessWidget {
  const PrivacyPolicyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with shield icon
        Center(
          child: Column(
            children: [
              Container(
                width: 80.w,
                height: 80.w,
                child: Image.asset( 
                  AppAssets.shieldIcon,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Privacy Policy',
                style: AppTextStyles.font18BlackSemiBold(context),
              ),
              SizedBox(height: 4.h),
              Text(
                'Medical Insurance App',
                style: AppTextStyles.font12GreyRegular(context),
              ),
              SizedBox(height: 8.h),
              Text(
                'Last updated: January 15, 2025',
                style: AppTextStyles.font10GreyRegular(context),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 24.h),
        
        PolicySection(
          title: '1. Introduction',
          content: 'Your privacy is important to us. This policy explains what data we collect, how we use it, and how we protect it.',
        ),
        
        PolicySection(
          title: '2. Information We Collect',
          items: const [
            'Personal Information (Name, DOB, Email, Phone, Insurance ID)',
            'Location Data (For nearby provider search, with user permission)',
            'Device & Usage Data (App interactions, error logs)',
          ],
        ),
        
        PolicySection(
          title: '3. How We Use Your Information',
          items: const [
            'Provide insurance services',
            'Improve app functionality',
            'Ensure security & fraud prevention',
            'Send important notifications',
          ],
          useCheckmarks: true,
        ),
        
        PolicySection(
          title: '4. How We Protect Your Data',
          items: const [
            'End-to-end encryption for data storage',
            'Strict access control measures',
          ],
          useIcons: true,
          iconType: Icons.lock,
        ),
        
        PolicySection(
          title: 'Do you have any questions?',
          content: 'Contact our privacy team:',
          email: 'Privacy@mediconsult.com',
          icon: Icons.email,
        ),
      ],
    );
  }
}
