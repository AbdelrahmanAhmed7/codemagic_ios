import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/cache/cache_service.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/constants/constants.dart';
import 'package:mediconsult/core/helpers/shared_pref_helper.dart';
import 'package:mediconsult/core/services/firebase_crashlytics_service.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/features/home/presentation/cubit/cubit/home_cubit.dart';
import 'package:mediconsult/features/home/presentation/cubit/cubit/home_state.dart';
import 'package:mediconsult/features/profile/presentation/widgets/logout_dialog.dart';
import 'package:mediconsult/features/profile/presentation/widgets/profile_header_widget.dart';
import 'package:mediconsult/features/profile/presentation/widgets/profile_section_widget.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:mediconsult/shared/widgets/custom_showcase.dart';
// ignore_for_file: deprecated_member_use

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey _personalInfoKey = GlobalKey();
  final GlobalKey _familyMembersKey = GlobalKey();
  final GlobalKey _changePasswordKey = GlobalKey();
  final GlobalKey _languageKey = GlobalKey();
  final GlobalKey _faqKey = GlobalKey();
  final GlobalKey _contactUsKey = GlobalKey();
  final GlobalKey _termsPrivacyKey = GlobalKey();
  final GlobalKey _logoutKey = GlobalKey();
  
  // Showcase state
  int _showcaseIndex = -1;

  @override
  void initState() {
    super.initState();
    // Check if home data exists, if not load from cache only (no API call)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<HomeCubit>();
      final state = cubit.state;
      // Only trigger if state is initial (not loaded, not loading, not failed)
      state.maybeWhen(
        initial: () =>
            cubit.getHomeInfo(context.locale.languageCode, forceRefresh: false),
        orElse: () {}, // Do nothing if already loaded/loading/failed
      );
    });
  }

  Future<void> _handleLogout(BuildContext context) async {
    // Show confirmation dialog
    final shouldLogout = await LogoutDialog.show(context);

    if (shouldLogout == true) {
      // Save onboarding status before clearing
      final hasSeenOnboarding = await SharedPrefHelper.getBool(
        SharedPrefKeys.hasSeenOnboarding,
      );

      // Clear token
      await SharedPrefHelper.removeData(SharedPrefKeys.userToken);

      // Update login status
      isLoggedInUser = false;

      // Clear all cache
      await CacheService.clearCache();
      await CacheService.clearFamilyCache();
      await CacheService.clearAllApprovalsCache();
      await CacheService.clearNotificationsCache();

      // Clear all SharedPreferences data
      await SharedPrefHelper.clearAllData();

      // Restore onboarding status (don't show onboarding again after logout)
      await SharedPrefHelper.setData(
        SharedPrefKeys.hasSeenOnboarding,
        hasSeenOnboarding,
      );

      // Clear secure storage (token)
      await SharedPrefHelper.clearAllSecuredData();

      // مسح بيانات Firebase Crashlytics
      await FirebaseCrashlyticsService.instance.clearUserData();

      // Navigate to login (this will trigger initState and clear login fields)
      if (context.mounted) {
        context.go('/login');
      }
    }
  }

  void _startShowcase() {
    setState(() {
      _showcaseIndex = 0;
    });
  }

  void _nextShowcase() {
    if (_showcaseIndex < _showcaseKeys.length - 1) {
      setState(() {
        _showcaseIndex++;
      });
    } else {
      _dismissShowcase();
    }
  }

  void _dismissShowcase() {
    setState(() {
      _showcaseIndex = -1;
    });
  }

  List<GlobalKey> get _showcaseKeys => [
        _personalInfoKey,
        _familyMembersKey,
        _changePasswordKey,
        _languageKey,
        _faqKey,
        _contactUsKey,
        _termsPrivacyKey,
        _logoutKey,
      ];

  List<String> get _showcaseDescriptions => [
        'tutorial.profile.personal_info'.tr(),
        'tutorial.profile.family_members'.tr(),
        'tutorial.profile.change_password'.tr(),
        'tutorial.profile.language'.tr(),
        'tutorial.profile.faq'.tr(),
        'tutorial.profile.contact_us'.tr(),
        'tutorial.profile.terms_privacy'.tr(),
        'tutorial.profile.log_out'.tr(),
      ];

  @override
  Widget build(BuildContext context) {
    return CustomShowcaseOverlay(
      targetKeys: _showcaseKeys,
      descriptions: _showcaseDescriptions,
      currentIndex: _showcaseIndex,
      onNext: _nextShowcase,
      onDismiss: _dismissShowcase,
      child: Scaffold(
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
                    _startShowcase();
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
                                CustomShowcase(
                                  key: _personalInfoKey,
                                  targetKey: _personalInfoKey,
                                  child: ProfileTileWidget(
                                    title: 'profile.personal_information'.tr(),
                                    image: AppAssets.personal,
                                    route: '/personal-information',
                                  ),
                                ),
                                CustomShowcase(
                                  key: _familyMembersKey,
                                  targetKey: _familyMembersKey,
                                  child: ProfileTileWidget(
                                    title: 'profile.family_members'.tr(),
                                    image: AppAssets.familyMembers,
                                    route: '/family-members',
                                  ),
                                ),
                              ],
                            ),
                            ProfileSectionWidget(
                              title: 'profile.settings'.tr(),
                              tiles: [
                                CustomShowcase(
                                  key: _changePasswordKey,
                                  targetKey: _changePasswordKey,
                                  child: ProfileTileWidget(
                                    title: 'profile.change_password'.tr(),
                                    image: AppAssets.change_password,
                                    route: '/change-password',
                                  ),
                                ),
                                CustomShowcase(
                                  key: _languageKey,
                                  targetKey: _languageKey,
                                  child: ProfileTileWidget(
                                    title: 'profile.language'.tr(),
                                    image: AppAssets.language,
                                    route: '/language',
                                  ),
                                ),
                              ],
                            ),
                            ProfileSectionWidget(
                              title: 'profile.help_support'.tr(),
                              tiles: [
                                CustomShowcase(
                                  key: _faqKey,
                                  targetKey: _faqKey,
                                  child: ProfileTileWidget(
                                    title: 'profile.faq'.tr(),
                                    image: AppAssets.faq,
                                    route: '/faq',
                                  ),
                                ),
                                CustomShowcase(
                                  key: _contactUsKey,
                                  targetKey: _contactUsKey,
                                  child: ProfileTileWidget(
                                    title: 'profile.contact_us'.tr(),
                                    image: AppAssets.contactUs,
                                    route: '/contact-us',
                                  ),
                                ),
                                CustomShowcase(
                                  key: _termsPrivacyKey,
                                  targetKey: _termsPrivacyKey,
                                  child: ProfileTileWidget(
                                    title: 'profile.terms_privacy'.tr(),
                                    image: AppAssets.terms,
                                    route: '/terms-policy',
                                  ),
                                ),
                              ],
                            ),
                            ProfileSectionWidget(
                              title: '',
                              tiles: [
                                CustomShowcase(
                                  key: _logoutKey,
                                  targetKey: _logoutKey,
                                  child: ProfileTileWidget(
                                    title: 'profile.log_out'.tr(),
                                    image: AppAssets.logout,
                                    onTap: () => _handleLogout(context),
                                  ),
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
