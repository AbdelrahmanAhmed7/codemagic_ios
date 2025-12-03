import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/network/data/network_provider_response_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mediconsult/shared/widgets/custom_showcase.dart';

class ProviderCard extends StatelessWidget {
  final NetworkProvider provider;
  final VoidCallback? onTap;
  final GlobalKey? navigateKey;
  final GlobalKey? phoneKey;

  const ProviderCard({
    super.key,
    required this.provider,
    this.onTap,
    this.navigateKey,
    this.phoneKey,
  });

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _openMaps() async {
    if (provider.latitude == 0 && provider.longitude == 0) {
      return;
    }

    try {
      final Uri googleMapsAppUri = Uri.parse(
        'google.navigation:q=${provider.latitude},${provider.longitude}',
      );

      if (await canLaunchUrl(googleMapsAppUri)) {
        await launchUrl(googleMapsAppUri);
        return;
      }

      final Uri mapsUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${provider.latitude},${provider.longitude}',
      );

      if (await canLaunchUrl(mapsUri)) {
        await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
      } else {
        final Uri originalUri = Uri.parse(provider.mapsUrl);
        await launchUrl(originalUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error opening maps: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Color(0xffF5F5F5),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.greyClr.withValues(alpha: 0.08),
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Logo + Name + City
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Provider Logo
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppColors.whiteClr,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: provider.hasLogo
                        ? CachedNetworkImage(
                            imageUrl: provider.providerLogo,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Padding(
                              padding: EdgeInsets.all(4.w),
                              child: Image.asset(
                                AppAssets.logo,
                                fit: BoxFit.contain,
                              ),
                            ),
                            errorWidget: (context, url, error) => Padding(
                              padding: EdgeInsets.all(4.w),
                              child: Image.asset(
                                AppAssets.logo,
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.all(4.w),
                            child: Image.asset(
                              AppAssets.logo,
                              fit: BoxFit.contain,
                            ),
                          ),
                  ),
                ),

                SizedBox(width: 12.w),

                // Provider Name and City
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Provider Name
                      Text(
                        provider.providerName,
                        style: AppTextStyles.font12BlackMedium(context),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 6.h),

                      // City with blue color
                      Text(
                        provider.city,
                        style: AppTextStyles.font14BlueMedium(
                          context,
                        ).copyWith(fontSize: 10.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Full Address with Icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(AppAssets.locationIcon, width: 16.w, height: 16.h),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    provider.fullAddress,
                    style: AppTextStyles.font12GreyRegular(context),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Phone Number with Icon (Clickable)
            GestureDetector(
              onTap: () => _makePhoneCall(provider.displayPhone),
              child: Row(
                children: [
                  Image.asset(
                    AppAssets.phoneIconNetwork,
                    width: 16.w,
                    height: 16.h,
                  ),
                  SizedBox(width: 8.w),
                  phoneKey == null
                      ? Text(
                          provider.mobile,
                          style: AppTextStyles.font12GreyRegular(context),
                        )
                      : CustomShowcase(
                          key: phoneKey!,
                          targetKey: phoneKey!,
                          child: Text(
                            provider.mobile,
                            style: AppTextStyles.font12GreyRegular(context),
                          ),
                        ),
                  Spacer(),
                  // Details Button
                  navigateKey == null
                      ? _NavigateButton(onOpen: _openMaps)
                      : CustomShowcase(
                          key: navigateKey!,
                          targetKey: navigateKey!,
                          child: _NavigateButton(onOpen: _openMaps),
                        ),
                ],
              ),
            ),
            if (phoneKey != null)
              const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }
}

class _NavigateButton extends StatelessWidget {
  final VoidCallback onOpen;
  const _NavigateButton({required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onOpen,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryClr,
        foregroundColor: AppColors.whiteClr,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 10.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            bottomRight: Radius.circular(12.r),
            topRight: Radius.circular(0.r),
            bottomLeft: Radius.circular(0.r),
          ),
        ),
        elevation: 0,
      ),
      child: Text(
        'network.navigate'.tr(),
        style: AppTextStyles.font14WhiteMedium(
          context,
        ).copyWith(fontSize: 10.sp),
      ),
    );
  }
}
