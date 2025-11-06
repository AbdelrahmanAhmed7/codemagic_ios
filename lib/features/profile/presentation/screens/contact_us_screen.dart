import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactCubit>().load(lang: context.locale.languageCode);
    });
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchEmail(String email) async {
    // Prefer Gmail app if installed
    final gmailApp = Uri.parse('googlegmail://co?to=$email');
    final mailto = Uri(scheme: 'mailto', path: email);
    try {
      if (await canLaunchUrl(gmailApp)) {
        await launchUrl(gmailApp, mode: LaunchMode.externalApplication);
        return;
      }
      if (await canLaunchUrl(mailto)) {
        await launchUrl(mailto, mode: LaunchMode.externalApplication);
        return;
      }
      final gmailWeb = Uri.parse('https://mail.google.com/mail/?view=cm&fs=1&to=$email');
      if (await canLaunchUrl(gmailWeb)) {
        await launchUrl(gmailWeb, mode: LaunchMode.externalApplication);
        return;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No email app available'.tr())),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open email client'.tr())),
        );
      }
    }
  }

  Future<void> _launchWhatsApp(String phone) async {
    final uri = Uri.parse('https://wa.me/${phone.replaceAll('+', '')}');
    await _launchUrl(uri.toString());
  }

  Future<void> _makePhoneCall(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
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
            PageHeader(title: 'profile.contact_us.title'.tr(), backPath: '/profile'),
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
                        String hotLine = '';
                        String email = '';
                        String whats = '';
                        String website = '';
                        String linkedIn = '';
                        String facebook = '';
                        String instagram = '';
                        if (state is Loaded) {
                          hotLine = state.data.data.hotLine;
                          email = state.data.data.email;
                          whats = state.data.data.whatsApp;
                          website = state.data.data.website;
                          linkedIn = state.data.data.linkedIn;
                          facebook = state.data.data.facebook;
                          instagram = state.data.data.instagram;
                        }
                        return ListView(
                      padding: EdgeInsets.all(16.w),
                      children: [
                        ContactTile(
                          assetPath: AppAssets.chatIcon,
                          title: 'contact_us.chat'.tr(),
                          subtitle: 'contact_us.chat_subtitle'.tr(),
                          onTap: () => context.push('/chat'),
                        ),
                        SizedBox(height: 12.h),
                        ContactTile(
                          assetPath: AppAssets.phoneContactIcon,
                          title: 'contact_us.phone'.tr(),
                          subtitle: hotLine,
                          onTap: hotLine.isEmpty ? () {} : () => _makePhoneCall(hotLine),
                        ),
                        SizedBox(height: 12.h),
                        ContactTile(
                          assetPath: AppAssets.emailIcon,
                          title: 'contact_us.email'.tr(),
                          subtitle: email,
                          onTap: email.isEmpty ? () {} : () => _launchEmail(email),
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
                          subtitle: whats,
                          onTap: whats.isEmpty ? () {} : () => _launchWhatsApp(whats),
                        ),
                        SizedBox(height: 8.h),
                        ContactTile(
                          assetPath: AppAssets.websiteIcon,
                          title: 'contact_us.website'.tr(),
                          subtitle: website,
                          onTap: website.isEmpty ? () {} : () => _launchUrl(website),
                        ),
                        SizedBox(height: 8.h),
                        ContactTile(
                          assetPath: AppAssets.linkedInIcon,
                          title: 'contact_us.linkedin'.tr(),
                          subtitle: linkedIn,
                          onTap: linkedIn.isEmpty ? () {} : () => _launchUrl(linkedIn),
                        ),
                        SizedBox(height: 8.h),
                        ContactTile(
                          assetPath: AppAssets.instagramIcon,
                          title: 'contact_us.instagram'.tr(),
                          subtitle: instagram,
                          onTap: instagram.isEmpty ? () {} : () => _launchUrl(instagram),
                        ),
                        SizedBox(height: 8.h),
                        ContactTile(
                          assetPath: AppAssets.facebookIcon,
                          title: 'Facebook',
                          subtitle: facebook,
                          onTap: facebook.isEmpty ? () {} : () => _launchUrl(facebook),
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