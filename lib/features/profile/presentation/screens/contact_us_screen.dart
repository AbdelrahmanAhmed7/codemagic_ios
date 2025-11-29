import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/services/url_launcher_service.dart';
import 'package:mediconsult/features/support/presentation/cubit/contact_cubit.dart';
import 'package:mediconsult/features/support/presentation/cubit/contact_state.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:mediconsult/features/profile/presentation/widgets/contact_tile.dart';
import 'package:easy_localization/easy_localization.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _urlLauncher = UrlLauncherService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactCubit>().load(lang: context.locale.languageCode);
    });
  }

  Future<void> _handleLaunch(
    Future<bool> Function() launchFunction,
    String errorMessage,
  ) async {
    final success = await launchFunction();
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage.tr()),
          backgroundColor: AppColors.errorClr,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyClr,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(
              title: 'profile.contact_us.title'.tr(),
              backPath: '/profile',
            ),
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
                    child: BlocBuilder<ContactCubit, ContactState>(
                      builder: (context, state) {
                        if (state is! Loaded) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final data = state.data.data;

                        return ListView(
                          padding: EdgeInsets.all(16.w),
                          children: [
                            // ContactTile(
                            //   assetPath: AppAssets.chatIcon,
                            //   title: 'contact_us.chat'.tr(),
                            //   subtitle: 'contact_us.chat_subtitle'.tr(),
                            //   onTap: () => context.push('/chat'),
                            // ),
                            // SizedBox(height: 12.h),
                            ContactTile(
                              assetPath: AppAssets.phoneContactIcon,
                              title: 'contact_us.phone'.tr(),
                              subtitle: data.hotLine,
                              onTap: data.hotLine.isEmpty
                                  ? null
                                  : () => _handleLaunch(
                                      () => _urlLauncher.makePhoneCall(
                                        data.hotLine,
                                      ),
                                      'contact_us.errors.phone',
                                    ),
                            ),
                            SizedBox(height: 12.h),
                            ContactTile(
                              assetPath: AppAssets.emailIcon,
                              title: 'contact_us.email'.tr(),
                              subtitle: data.email,
                              onTap: data.email.isEmpty
                                  ? null
                                  : () => _handleLaunch(
                                      () =>
                                          _urlLauncher.launchEmail(data.email),
                                      'contact_us.errors.email',
                                    ),
                            ),
                            SizedBox(height: 20.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Text(
                                'contact_us.other_contacts'.tr(),
                                style: AppTextStyles.font16BlueMedium(context),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            ContactTile(
                              assetPath: AppAssets.whatsappIcon,
                              title: 'contact_us.whatsapp'.tr(),
                              subtitle: data.whatsApp,
                              onTap: data.whatsApp.isEmpty
                                  ? null
                                  : () => _handleLaunch(
                                      () => _urlLauncher.launchWhatsApp(
                                        data.whatsApp,
                                      ),
                                      'contact_us.errors.whatsapp',
                                    ),
                            ),
                            SizedBox(height: 8.h),
                            ContactTile(
                              assetPath: AppAssets.websiteIcon,
                              title: 'contact_us.website'.tr(),
                              subtitle: data.website,
                              onTap: data.website.isEmpty
                                  ? null
                                  : () => _handleLaunch(
                                      () =>
                                          _urlLauncher.launchURL(data.website),
                                      'contact_us.errors.website',
                                    ),
                            ),
                            SizedBox(height: 8.h),
                            ContactTile(
                              assetPath: AppAssets.linkedInIcon,
                              title: 'contact_us.linkedin'.tr(),
                              subtitle: data.linkedIn,
                              onTap: data.linkedIn.isEmpty
                                  ? null
                                  : () => _handleLaunch(
                                      () =>
                                          _urlLauncher.launchURL(data.linkedIn),
                                      'contact_us.errors.link',
                                    ),
                            ),
                            SizedBox(height: 8.h),
                            ContactTile(
                              assetPath: AppAssets.instagramIcon,
                              title: 'contact_us.instagram'.tr(),
                              subtitle: data.instagram,
                              onTap: data.instagram.isEmpty
                                  ? null
                                  : () => _handleLaunch(
                                      () => _urlLauncher.launchURL(
                                        data.instagram,
                                      ),
                                      'contact_us.errors.link',
                                    ),
                            ),
                            SizedBox(height: 8.h),
                            ContactTile(
                              assetPath: AppAssets.facebookIcon,
                              title: 'Facebook',
                              subtitle: data.facebook,
                              onTap: data.facebook.isEmpty
                                  ? null
                                  : () => _handleLaunch(
                                      () => _urlLauncher.launchFacebook(
                                        data.facebook,
                                      ),
                                      'contact_us.errors.link',
                                    ),
                            ),
                          ],
                        );
                      },
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
