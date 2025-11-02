import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/network/connectivity_service.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';

/// Banner widget that shows when device is offline
class OfflineBanner extends StatefulWidget {
  const OfflineBanner({super.key});

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner> {
  bool _isOffline = false;
  StreamSubscription<bool>? _subscription;

  @override
  void initState() {
    super.initState();
    _initializeConnectivity();
  }

  Future<void> _initializeConnectivity() async {
    // Check initial status
    final isOnline = await ConnectivityService.instance.checkConnectivity();
    if (mounted) {
      setState(() {
        _isOffline = !isOnline;
      });
    }

    // Listen to connectivity changes
    _subscription = ConnectivityService.instance.connectivityStream.listen(
      (isOnline) {
        if (mounted) {
          setState(() {
            _isOffline = !isOnline;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOffline) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: AppColors.errorClr,
      child: Row(
        children: [
          Icon(
            Icons.wifi_off,
            color: Colors.white,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'common.no_internet'.tr(),
              style: AppTextStyles.font14WhiteRegular(context).copyWith(
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

