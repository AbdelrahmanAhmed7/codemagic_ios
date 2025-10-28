import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/approval_request/data/approvals_models.dart';

class ApprovalDetailsBottomSheet extends StatelessWidget {
  final ApprovalItem approval;

  const ApprovalDetailsBottomSheet({
    super.key,
    required this.approval,
  });

  static void show(BuildContext context, ApprovalItem approval) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ApprovalDetailsBottomSheet(approval: approval),
    );
  }

  Color _getStatusColor() {
    switch (approval.status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return AppColors.greyClr;
    }
  }

  String _getStatusText() {
    switch (approval.status.toLowerCase()) {
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'pending':
        return 'Pending';
      default:
        return approval.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteClr,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.greyClr.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                // Logo/Icon
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryClr,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      '#',
                      style: TextStyle(
                        color: AppColors.whiteClr,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${approval.status} details',
                        style: TextStyle(
                          color: AppColors.blackClr,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: _getStatusColor().withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          _getStatusText(),
                          style: TextStyle(
                            color: _getStatusColor(),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: AppColors.greyClr.withValues(alpha: 0.2)),

          // Details
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Request Number
                  _DetailRow(
                    icon: Icons.numbers,
                    iconColor: AppColors.primaryClr,
                    label: 'Request Number:',
                    value: approval.approvalNumber,
                  ),
                  SizedBox(height: 16.h),

                  // Approval Date
                  _DetailRow(
                    icon: Icons.calendar_today,
                    iconColor: Colors.blue,
                    label: 'Approval Date:',
                    value: approval.date,
                  ),
                  SizedBox(height: 16.h),

                  // Created Time
                  _DetailRow(
                    icon: Icons.access_time,
                    iconColor: Colors.purple,
                    label: 'Created Time:',
                    value: approval.time,
                  ),
                  SizedBox(height: 24.h),

                  // Approval/Rejected/Pending Details
                  Text(
                    '${_getStatusText()} Details',
                    style: AppTextStyles.font14BlackMedium(context),
                  ),
                  SizedBox(height: 12.h),

                  // Medication Name (Mock data)
                  _BulletPoint(
                    text: 'Medication Name: Panadol (Paracetamol 500mg)',
                  ),
                  SizedBox(height: 8.h),

                  // Coverage Details (Mock data)
                  if (approval.status.toLowerCase() == 'approved') ...[
                    _BulletPoint(
                      text: 'Coverage Details: 85% insurance coverage, 15% co-payment',
                    ),
                    SizedBox(height: 8.h),
                    _BulletPoint(
                      text: 'Prescription Validity: Until March 03, 2025',
                    ),
                  ],

                  // Rejected Reason (Mock data)
                  if (approval.status.toLowerCase() == 'rejected') ...[
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red, size: 20.sp),
                              SizedBox(width: 8.w),
                              Text(
                                'Rejected Reason:',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          _BulletPoint(
                            text: 'Medication not covered under your insurance plan',
                            color: Colors.red.shade700,
                          ),
                          SizedBox(height: 4.h),
                          _BulletPoint(
                            text: 'Next Step: Contact your doctor for alternative medications',
                            color: Colors.red.shade700,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.help_outline, color: Colors.orange, size: 20.sp),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              'Need Assistance? Contact our support team for further help',
                              style: TextStyle(
                                color: Colors.orange.shade700,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Pending Details (Mock data)
                  if (approval.status.toLowerCase() == 'pending') ...[
                    _BulletPoint(
                      text: 'Review Stage: Under verification by insurance provider',
                    ),
                    SizedBox(height: 8.h),
                    _BulletPoint(
                      text: 'Next Step: You will receive a notification once a decision is made',
                    ),
                  ],

                  SizedBox(height: 24.h),

                  // Close Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryClr,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Close',
                        style: TextStyle(
                          color: AppColors.whiteClr,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: iconColor, size: 18.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.font12GreyRegular(context),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: AppTextStyles.font14BlackMedium(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  final Color? color;

  const _BulletPoint({
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 6.h, right: 8.w),
          width: 6.w,
          height: 6.w,
          decoration: BoxDecoration(
            color: color ?? AppColors.blackClr,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: color ?? AppColors.blackClr,
              fontSize: 13.sp,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
