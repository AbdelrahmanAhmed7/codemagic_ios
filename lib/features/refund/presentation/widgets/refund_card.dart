import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/refund/data/refund_list_models.dart';
import 'package:mediconsult/features/refund/repository/refund_repository.dart';
import 'package:mediconsult/core/di/service_locator.dart';
import 'package:mediconsult/core/utils/pdf_helper.dart';
import 'package:mediconsult/core/utils/status_helper.dart';
import 'package:mediconsult/core/utils/date_formatter.dart';

class RefundCard extends StatelessWidget {
  final RefundItem item;
  
  const RefundCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final Color statusColor = StatusHelper.getStatusColor(item.statusChar);
    final String statusLabel = StatusHelper.getStatusLabel(item.statusChar, 'refund_history');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with gradient
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryClr,
                  AppColors.primaryClr.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.receipt_long_rounded,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${'refund_history.request_number'.tr()}: ${item.approvalNumber}',
                        style: AppTextStyles.font14WhiteMedium(context).copyWith(fontSize: 12.sp),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    statusLabel,
                    style: AppTextStyles.font12WhiteRegular(context),
                  ),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                _buildInfoRow(
                  context,
                  Icons.calendar_today_rounded,
                  'refund_history.date'.tr(),
                  item.date,
                ),
                SizedBox(height: 12.h),
                _buildInfoRow(
                  context,
                  Icons.access_time_rounded,
                  'refund_history.time'.tr(),
                  DateFormatter.formatTime(item.time),
                ),
                SizedBox(height: 16.h),
                _buildViewDetailsButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.greyClr.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: AppColors.primaryClr.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(
              icon,
              size: 16.sp,
              color: AppColors.primaryClr,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            label,
            style: AppTextStyles.font10BlackMedium(context).copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.font10BlackMedium(context),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewDetailsButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => _openRefundPdf(context),
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

  Future<void> _openRefundPdf(BuildContext context) async {
    await PdfHelper.openPdf(
      context: context,
      fetchPdf: () => sl<RefundRepository>().getRefundPdf(
        lang: context.locale.languageCode,
        refundId: item.id,
      ),
      errorMessageKey: 'refund_history.cannot_open_pdf',
    );
  }

}