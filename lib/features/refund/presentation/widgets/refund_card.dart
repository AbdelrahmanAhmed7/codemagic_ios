import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/features/refund/data/refund_list_models.dart';

class RefundCard extends StatelessWidget {
  final RefundItem item;
  
  const RefundCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _statusColor(item.statusChar);
    final Color backgroundColor = _backgroundColorForStatus(item.statusChar);
    final String statusLabel = _statusLabel(item.statusChar);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(12.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogo(),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, statusColor, statusLabel),
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

  Widget _buildLogo() {
    return Container(
      width: 69.w,
      height: 69.w,
      decoration: BoxDecoration(
        color: AppColors.primaryClr,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Image.asset(AppAssets.logo, fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color statusColor, String statusLabel) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${'refund_history.request_number'.tr()}${item.approvalNumber}',
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
          '${'refund_history.date'.tr()}${item.date}',
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
          '${'refund_history.time'.tr()}${item.time}',
          style: AppTextStyles.font10GreyRegular(context),
        ),
      ],
    );
  }

  Widget _buildViewDetailsButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          'refund_history.view_details'.tr(),
          style: AppTextStyles.font12BlueMedium(context),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'A':
        return const Color(0xFF22C55E);
      case 'R':
        return const Color(0xFFEF4444);
      case 'P':
      default:
        return const Color(0xFF9CA3AF);
    }
  }

  Color _backgroundColorForStatus(String status) {
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

  String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'A':
        return 'refund_history.status.approved'.tr();
      case 'R':
        return 'refund_history.status.rejected'.tr();
      case 'P':
      default:
        return 'refund_history.status.pending'.tr();
    }
  }
}
