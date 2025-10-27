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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().getHomeInfo('en');
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
              const PageHeader(title: 'Profile', backPath: '/home'),
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
                                initial: () {
                                  return const ProfileHeaderShimmer();
                                },
                                loading: () {
                                  return const ProfileHeaderShimmer();
                                },
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
                                          borderRadius: BorderRadius.circular(8.r),
                                          child: data.memberPhoto != null ? CachedNetworkImage(
                                                  imageUrl: data.memberPhoto!,
                                                  placeholder: (context, url) => Image.asset(
                                                    AppAssets.profile,
                                                  ),
                                                  errorWidget: (context, url, error) => Image.asset(
                                                    AppAssets.profile,
                                                  ),
                                                )
                                              : Image.asset(
                                                  AppAssets.profile,
                                                ),
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data.memberName,
                                              style: AppTextStyles.font14BlackMedium,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4.h),
                                            RichText(
                                              text: TextSpan(
                                                style: AppTextStyles.font10GreyRegular,
                                                children: [
                                                  const TextSpan(text: 'Member ID: '),
                                                  TextSpan(
                                                    text: data.memberId.toString(),
                                                    style: AppTextStyles.font12BlueRegular,
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Error loading profile',
                                              style: AppTextStyles.font14BlackMedium,
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              message,
                                              style: AppTextStyles.font10GreyRegular,
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
                            title: 'Account',
                            tiles: const [
                              _Tile(
                                title: 'Personal Information',
                                image: AppAssets.personal,
                              ),
                              _Tile(
                                title: 'Family Members',
                                image: AppAssets.familyMembers,
                              ),
                              _Tile(
                                title: 'Insurance Plan',
                                image: AppAssets.insurance,
                              ),
                            ],
                          ),
                          _Section(
                            title: 'Setting',
                            tiles: const [
                              _Tile(
                                title: 'Change Password',
                                image: AppAssets.change_password,
                              ),
                              _Tile(
                                title: 'Language',
                                image: AppAssets.language,
                              ),
                            ],
                          ),
                          _Section(
                            title: 'Help & Support',
                            tiles: const [
                              _Tile(title: 'FAQ', image: AppAssets.faq),
                              _Tile(
                                title: 'Contact us',
                                image: AppAssets.contactUs,
                              ),
                              _Tile(
                                title: 'Terms & Privacy Policy',
                                image: AppAssets.terms,
                              ),
                            ],
                          ),
                          _Section(
                            title: '',
                            tiles: const [
                              _Tile(title: 'Log Out', image: AppAssets.logout),
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
              child: Text(title, style: AppTextStyles.font12BlueRegular),
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
      title: Text(title, style: AppTextStyles.font12BlackRegular),
      trailing: Image.asset(AppAssets.chevronRight, width: 24.w, height: 29.h),
      onTap: () {
        if (title == 'Personal Information') {
          context.go('/personal-information');
        } else if (title == 'Family Members') {
          context.go('/family-members');
        } else if (title == 'Insurance Plan') {
          context.go('/insurance-plan');
        } else if (title == 'FAQ') {
          context.go('/faq');
        } else if (title == 'Contact us') {
          context.go('/contact-us');
        } else if (title == 'Terms & Privacy Policy') {
          context.go('/terms-policy');
        } else if (title == 'Change Password') {
          context.go('/change-password');
        } else if (title == 'Language') {
          context.go('/language');
        }
      },
    );
  }
}
