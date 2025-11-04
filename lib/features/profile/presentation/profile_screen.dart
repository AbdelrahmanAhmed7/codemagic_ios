import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/features/home/presentation/cubit/cubit/home_cubit.dart';
import 'package:mediconsult/features/home/presentation/cubit/cubit/home_state.dart';
import 'package:mediconsult/features/profile/presentation/widgets/profile_header_widget.dart';
import 'package:mediconsult/features/profile/presentation/widgets/profile_section_widget.dart';
import 'package:showcaseview/showcaseview.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey _personalInfoKey = GlobalKey();
  final GlobalKey _changePasswordKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    // Load home data if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<HomeCubit>();
      if (cubit.state is! Loaded) {
        cubit.getHomeInfo('en');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (context) => Scaffold(
        backgroundColor: AppColors.lightGreyClr,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageHeader(
                  title: 'profile.title'.tr(),
                  backPath: '/home',
                  onHelp: () {
                    ShowCaseWidget.of(
                      context,
                    ).startShowCase([_personalInfoKey, _changePasswordKey]);
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
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ProfileHeaderWidget(),
                            SizedBox(height: 16.h),
                            ProfileSectionWidget(
                              title: 'profile.account'.tr(),
                              tiles: [
                                Showcase(
                                  key: _personalInfoKey,
                                  description:
                                      'View and edit your personal information',
                                  child: ProfileTileWidget(
                                    title: 'profile.personal_information'.tr(),
                                    image: AppAssets.personal,
                                    route: '/personal-information',
                                  ),
                                ),
                                ProfileTileWidget(
                                  title: 'profile.family_members'.tr(),
                                  image: AppAssets.familyMembers,
                                  route: '/family-members',
                                ),
                                ProfileTileWidget(
                                  title: 'profile.insurance_plan'.tr(),
                                  image: AppAssets.insurance,
                                  route: '/insurance-plan',
                                ),
                              ],
                            ),
                            ProfileSectionWidget(
                              title: 'profile.settings'.tr(),
                              tiles: [
                                Showcase(
                                  key: _changePasswordKey,
                                  description: 'Change your account password',
                                  child: ProfileTileWidget(
                                    title: 'profile.change_password'.tr(),
                                    image: AppAssets.change_password,
                                    route: '/change-password',
                                  ),
                                ),
                                ProfileTileWidget(
                                  title: 'profile.language'.tr(),
                                  image: AppAssets.language,
                                  route: '/language',
                                ),
                              ],
                            ),
                            ProfileSectionWidget(
                              title: 'profile.help_support'.tr(),
                              tiles: [
                                ProfileTileWidget(
                                  title: 'profile.faq'.tr(),
                                  image: AppAssets.faq,
                                  route: '/faq',
                                ),
                                ProfileTileWidget(
                                  title: 'profile.contact_us'.tr(),
                                  image: AppAssets.contactUs,
                                  route: '/contact-us',
                                ),
                                ProfileTileWidget(
                                  title: 'profile.terms_privacy'.tr(),
                                  image: AppAssets.terms,
                                  route: '/terms-policy',
                                ),
                              ],
                            ),
                            ProfileSectionWidget(
                              title: '',
                              tiles: [
                                ProfileTileWidget(
                                  title: 'profile.log_out'.tr(),
                                  image: AppAssets.logout,
                                  route: '/logout',
                                ),
                              ],
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
