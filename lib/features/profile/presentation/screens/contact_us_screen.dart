import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:mediconsult/features/profile/presentation/widgets/contact_tile.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyClr,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(title: 'Contact Us', backPath: '/profile'),
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
                    child: ListView(
                      padding: EdgeInsets.all(16.w),
                      children: [
                        ContactTile(
                          assetPath: AppAssets.chatIcon,
                          title: 'Chat',
                          subtitle: 'Chat with our team',
                          onTap: () => context.go('/chat'),
                        ),
                        SizedBox(height: 12.h),
                        ContactTile(
                          assetPath: AppAssets.phoneContactIcon,
                          title: 'Phone Number',
                          subtitle: '+20 1083423719',
                          onTap: () {},
                        ),
                        SizedBox(height: 12.h),
                        ContactTile(
                          assetPath: AppAssets.emailIcon,
                          title: 'Email',
                          subtitle: 'support@Mediconsult.com',
                          onTap: () {},
                        ),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Text(
                            'Other Contacts',
                            style: AppTextStyles.font16BlueMedium,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        ContactTile(
                          assetPath: AppAssets.whatsappIcon,
                          title: 'WhatsApp',
                          subtitle: '',
                          onTap: () {},
                        ),
                        SizedBox(height: 8.h),
                        ContactTile(
                          assetPath: AppAssets.websiteIcon,
                          title: 'Website',
                          subtitle: '',
                          onTap: () {},
                        ),
                        SizedBox(height: 8.h),
                        ContactTile(
                          assetPath: AppAssets.linkedInIcon,
                          title: 'LinkedIn',
                          subtitle: '',
                          onTap: () {},
                        ),
                        SizedBox(height: 8.h),
                        ContactTile(
                          assetPath: AppAssets.instagramIcon,
                          title: 'Instagram',
                          subtitle: '',
                          onTap: () {},
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