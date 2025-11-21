import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'English'; 

  final List<Map<String, String>> _languages = [
    {
      'code': 'en',
      'name': 'English',
      'nativeName': 'English',
    },
    {
      'code': 'ar',
      'name': 'Arabic',
      'nativeName': 'العربية',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyClr,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const PageHeader(title: 'Language', backPath: '/profile'),
              Transform.translate(
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
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        children: [
                          // Illustration section
                          _buildIllustration(),
                          
                          SizedBox(height: 32.h),
                          
                          // Language selection card
                          _buildLanguageCard(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Image.asset(AppAssets.languageSelect);
  }

  Widget _buildLanguageCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.whiteClr,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Change Language',
            style: AppTextStyles.font16BlackMedium.copyWith(
              color: Color(0xff083D91),
            ),
          ),
          
          SizedBox(height: 20.h),
          
          // Language options
          ..._languages.map((language) => _buildLanguageOption(language)),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(Map<String, String> language) {
    final bool isSelected = _selectedLanguage == language['name'];
    
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedLanguage = language['name']!;
          });
          
          // TODO: Implement language change functionality
          print('Selected language: ${language['name']}');
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Language changed to ${language['nativeName']}'),
              backgroundColor: AppColors.primaryClr,
            ),
          );
        },
        child: Row(
          children: [
            Expanded(
              child: Text(
                language['nativeName']!,
                style: AppTextStyles.font14BlackRegular,
              ),
            ),
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryClr : AppColors.greyClr,
                  width: 2,
                ),
                color: isSelected ? AppColors.primaryClr : AppColors.whiteClr,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: AppColors.whiteClr,
                      size: 16.sp,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
