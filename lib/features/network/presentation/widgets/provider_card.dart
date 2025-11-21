import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/network/data/network_provider_response_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class ProviderCard extends StatelessWidget {
  final NetworkProvider provider;
  final VoidCallback? onTap;

  const ProviderCard({super.key, required this.provider, this.onTap});

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
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.w,
                                  color: AppColors.primaryClr,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.local_hospital,
                              size: 28.sp,
                              color: AppColors.greyClr,
                            ),
                          )
                        : Icon(
                            Icons.local_hospital,
                            size: 28.sp,
                            color: AppColors.greyClr,
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
                        style: AppTextStyles.font12BlackMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 6.h),

                      // City with blue color
                      Text(
                        provider.city,
                        style: AppTextStyles.font14BlueMedium.copyWith(
                          fontSize: 10.sp,
                        ),
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
                    style: AppTextStyles.font12GreyRegular,
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
                  Text(provider.mobile, style: AppTextStyles.font12GreyRegular),
                  Spacer(),
                  // Details Button
                  ElevatedButton(
                    onPressed:
                        (provider.latitude != 0 && provider.longitude != 0)
                        ? _openMaps
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryClr,
                      foregroundColor: AppColors.whiteClr,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.r),
                          bottomRight: Radius.circular(8.r),
                          topRight: Radius.circular(0.r),
                          bottomLeft: Radius.circular(0.r),
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Navigate',
                      style: AppTextStyles.font14WhiteMedium.copyWith(
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
