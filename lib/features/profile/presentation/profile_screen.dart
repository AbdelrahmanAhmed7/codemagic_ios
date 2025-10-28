import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/features/home/presentation/cubit/cubit/home_cubit.dart';
import 'package:mediconsult/features/home/presentation/cubit/cubit/home_state.dart';
import 'package:mediconsult/features/profile/presentation/widgets/profile_header_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load home data if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<HomeCubit>();
      if (cubit.state is! Loaded) {
        cubit.getHomeInfo(context.locale.languageCode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyClr,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeader(title: 'profile.title'.tr(), backPath: '/home'),
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
                          BlocBuilder<HomeCubit, HomeCubitState>(
                            builder: (context, state) {
                              return state.when(
                                initial: () => const ProfileHeaderShimmer(),
                                loading: () => const ProfileHeaderShimmer(),
                                loaded: (homeResponse) {
                                  final data = homeResponse.data;
                                  if (data == null) {
                                    return const ProfileHeaderShimmer();
                                  }
                                  return Row(
                                    children: [
                                      Container(
                                        width: 74.w,
                                        height: 90.w,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          child:
                                              data.memberPhoto != null &&
                                                  data.memberPhoto!.isNotEmpty
                                              ? CachedNetworkImage(
                                                  imageUrl: data.memberPhoto!,
                                                  placeholder: (context, url) =>
                                                      Image.asset(
                                                        AppAssets.profile,
                                                      ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image.asset(
                                                            AppAssets.profile,
                                                          ),
                                                )
                                              : Image.asset(AppAssets.profile),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data.memberName,
                                              style: AppTextStyles
                                                  .font14BlackMedium(context),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4.h),
                                            RichText(
                                              text: TextSpan(
                                                style: AppTextStyles
                                                    .font10GreyRegular(context),
                                                children: [
                                                  TextSpan(
                                                    text: 'profile.member_id'
                                                        .tr(),
                                                  ),
                                                  TextSpan(
                                                    text: data.memberId
                                                        .toString(),
                                                    style: AppTextStyles
                                                        .font12BlueRegular(context),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                failed: (message) {
                                  return Row(
                                    children: [
                                      Container(
                                        width: 74.w,
                                        height: 90.w,
                                        child: Image.asset(AppAssets.profile),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'profile.error_loading_profile'
                                                  .tr(),
                                              style: AppTextStyles
                                                  .font14BlackMedium(context),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              message,
                                              style: AppTextStyles
                                                  .font10GreyRegular(context),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(height: 16.h),
                          _Section(
                            title: 'profile.account'.tr(),
                            tiles: [
                              _Tile(
                                title: 'profile.personal_information'.tr(),
                                image: AppAssets.personal,
                              ),
                              _Tile(
                                title: 'profile.family_members'.tr(),
                                image: AppAssets.familyMembers,
                              ),
                              _Tile(
                                title: 'profile.insurance_plan'.tr(),
                                image: AppAssets.insurance,
                              ),
                            ],
                          ),
                          _Section(
                            title: 'profile.settings'.tr(),
                            tiles: [
                              _Tile(
                                title: 'profile.change_password'.tr(),
                                image: AppAssets.change_password,
                              ),
                              _Tile(
                                title: 'profile.language'.tr(),
                                image: AppAssets.language,
                              ),
                            ],
                          ),
                          _Section(
                            title: 'profile.help_support'.tr(),
                            tiles: [
                              _Tile(
                                title: 'profile.faq'.tr(),
                                image: AppAssets.faq,
                              ),
                              _Tile(
                                title: 'profile.contact_us'.tr(),
                                image: AppAssets.contactUs,
                              ),
                              _Tile(
                                title: 'profile.terms_privacy'.tr(),
                                image: AppAssets.terms,
                              ),
                            ],
                          ),
                          _Section(
                            title: '',
                            tiles: [
                              _Tile(
                                title: 'profile.log_out'.tr(),
                                image: AppAssets.logout,
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
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.tiles});
  final String title;
  final List<_Tile> tiles;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
              child: Text(title, style: AppTextStyles.font12BlueRegular(context)),
            ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.whiteClr,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xffECECEC)),
            ),
            child: Column(children: tiles),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.title, required this.image});
  final String title;
  final String image;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(image, width: 24.h, height: 24.h),
      title: Text(title, style: AppTextStyles.font12BlackRegular(context)),
      trailing: context.locale.languageCode == 'ar'
          ? Transform.rotate(
              angle: 3.14159, // 180 degrees in radians
              child: Image.asset(
                AppAssets.chevronRight,
                width: 24.w,
                height: 29.h,
              ),
            )
          : Image.asset(AppAssets.chevronRight, width: 24.w, height: 29.h),
      onTap: () {
        if (title == 'profile.personal_information'.tr()) {
          context.go('/personal-information');
        } else if (title == 'profile.family_members'.tr()) {
          context.go('/family-members');
        } else if (title == 'profile.insurance_plan'.tr()) {
          context.go('/insurance-plan');
        } else if (title == 'profile.faq'.tr()) {
          context.go('/faq');
        } else if (title == 'profile.contact_us'.tr()) {
          context.go('/contact-us');
        } else if (title == 'profile.terms_privacy'.tr()) {
          context.go('/terms-policy');
        } else if (title == 'profile.change_password'.tr()) {
          context.go('/change-password');
        } else if (title == 'profile.language'.tr()) {
          context.go('/language');
        } else if (title == 'profile.log_out'.tr()) {
          // يمكن إضافة منطق تسجيل الخروج هنا
        }
      },
    );
  }
}
