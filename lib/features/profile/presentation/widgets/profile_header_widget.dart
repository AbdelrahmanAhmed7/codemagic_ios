import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/home/presentation/cubit/cubit/home_cubit.dart';
import 'package:mediconsult/features/home/presentation/cubit/cubit/home_state.dart';
import 'package:mediconsult/features/profile/presentation/widgets/profile_header_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mediconsult/core/widgets/image_shimmer.dart';

/// Profile header widget showing user info
class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeCubitState>(
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
                  height: 74.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: data.memberPhoto != null && data.memberPhoto!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: data.memberPhoto!,
                          fit: BoxFit.cover,
                          memCacheWidth: 148,
                          memCacheHeight: 148,
                          maxWidthDiskCache: 148,
                          maxHeightDiskCache: 148,
                          placeholder: (context, url) => const ImageShimmer.circle(),
                          errorWidget: (context, url, error) =>
                              Image.asset(AppAssets.profile, fit: BoxFit.cover),
                        )
                      : const ImageShimmer.circle(),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.memberName,
                        style: AppTextStyles.font14BlackMedium(context),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      RichText(
                        text: TextSpan(
                          style: AppTextStyles.font10GreyRegular(context),
                          children: [
                            TextSpan(
                              text: 'profile.member_id'.tr(),
                            ),
                            TextSpan(
                              text: data.memberId.toString(),
                              style: AppTextStyles.font12BlueRegular(context),
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
                  height: 74.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(AppAssets.profile, fit: BoxFit.cover),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'profile.error_loading_profile'.tr(),
                        style: AppTextStyles.font14BlackMedium(context),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        message,
                        style: AppTextStyles.font10GreyRegular(context),
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
    );
  }
}

