import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/features/approval_request/data/approvals_models.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/approval_details_bottom_sheet.dart';

class ApprovalCard extends StatelessWidget {
  final ApprovalItem item;
  const ApprovalCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _getStatusColor(item.statusChar);
    final Color backgroundColor = _getBackgroundColorForStatus(item.statusChar);
    final String statusLabel = _getStatusLabel(item.statusChar);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(12.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProviderLogo(),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderRow(context, statusColor, statusLabel),
                SizedBox(height: 6.h),
                _buildDateRow(context),
                SizedBox(height: 4.h),
                _buildTimeRow(context),
                SizedBox(height: 8.h),
                _buildViewDetailsButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderLogo() {
    return Container(
      width: 69.w,
      height: 69.w,
      decoration: BoxDecoration(
        color: AppColors.primaryClr,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: (item.providerLogo != null &&
              item.providerLogo!.isNotEmpty &&
              item.providerLogo!.startsWith('http'))
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                imageUrl: item.providerLogo!,
                fit: BoxFit.cover,
                memCacheWidth: 138,
                memCacheHeight: 138,
                maxWidthDiskCache: 138,
                maxHeightDiskCache: 138,
                placeholder: (context, url) => Center(
                  child: SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Image.asset(AppAssets.logo, fit: BoxFit.contain),
                ),
              ),
            )
          : Padding(
              padding: EdgeInsets.all(8.w),
              child: Image.asset(AppAssets.logo, fit: BoxFit.contain),
            ),
    );
  }

  Widget _buildHeaderRow(BuildContext context, Color statusColor, String statusLabel) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${'approval_history.request_number'.tr()}${item.approvalNumber}',
            style: AppTextStyles.font10GreyRegular(context),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Text(
            statusLabel,
            style: TextStyle(
              color: Colors.white,
              fontSize: 8.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRow(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.calendar_today, size: 14.sp, color: AppColors.blueClr),
        SizedBox(width: 5.w),
        Text(
          '${'approval_history.date'.tr()}${item.date}',
          style: AppTextStyles.font10GreyRegular(context),
        ),
      ],
    );
  }

  Widget _buildTimeRow(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.access_time, size: 14.sp, color: AppColors.blueClr),
        SizedBox(width: 5.w),
        Text(
          '${'approval_history.time'.tr()}${item.time}',
          style: AppTextStyles.font10GreyRegular(context),
        ),
      ],
    );
  }

  Widget _buildViewDetailsButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => ApprovalDetailsBottomSheet.show(context, item),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          'approval_history.view_details'.tr(),
          style: AppTextStyles.font12BlueMedium(context),
        ),
      ),
    );
  }

  static Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'A':
        return const Color(0xFF349859);
      case 'R':
        return const Color(0xFFB92828);
      case 'P':
      default:
        return const Color(0xFF999999);
    }
  }

  static Color _getBackgroundColorForStatus(String status) {
    switch (status.toUpperCase()) {
      case 'A':
        return const Color(0xFFD9F2E2);
      case 'R':
        return const Color(0xFFF5E1E9);
      case 'P':
      default:
        return const Color(0xFFF2F2F2);
    }
  }

  static String _getStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'A':
        return 'approval_history.status.approved'.tr();
      case 'R':
        return 'approval_history.status.rejected'.tr();
      case 'P':
      default:
        return 'approval_history.status.pending'.tr();
    }
  }
}
