import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/features/home/data/home_response_model.dart';

class OngoingRequestWidget extends StatelessWidget {
  final HomeData data;
  final VoidCallback? onSeeAll;

  const OngoingRequestWidget({super.key, required this.data, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final approvals = data.approvals;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ongoing Requests', style: AppTextStyles.font14BlackMedium),
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                'See All',
                style: AppTextStyles.font14PrimaryMedium.copyWith(
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Check if approvals exist
        if (approvals.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Text(
                'No ongoing requests',
                style: AppTextStyles.font12GreyRegular,
              ),
            ),
          )
        else
          // Horizontal ListView of approvals
          SizedBox(
            height: 140.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: approvals.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final approval = approvals[index];
                return SizedBox(
                  width: 300.w,
                  child: _buildApprovalCard(context, approval),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildApprovalCard(BuildContext context, Approval approval) {
    return Container(
      width: double.infinity,
      height: 120.h,
      decoration: BoxDecoration(
        color: AppColors.whiteClr,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyClr.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.greyClr.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left color indicator
          Container(
            width: 6.w,
            height: 120.h,
            decoration: BoxDecoration(
              color: _getStatusColor(approval.status),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Provider logo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: approval.providerLogo.isNotEmpty
                            ? Image.network(
                                approval.providerLogo,
                                width: 48.w,
                                height: 60.h,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  AppAssets.alfaLogo,
                                  width: 48.w,
                                  height: 60.h,
                                ),
                              )
                            : Image.asset(
                                AppAssets.logo,
                                width: 48.w,
                                height: 60.h,
                              ),
                      ),
                      SizedBox(width: 12.w),

                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              approval.providerName.trim(),
                              style: AppTextStyles.font14BlackMedium.copyWith(
                                color: const Color(0xff062860),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              " Service Type : ${approval.notes.isNotEmpty
                                  ? approval.notes
                                  : "No notes provided"}",
                              style: AppTextStyles.font12GreyRegular,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              "Date: ${approval.createdDate.split('T').first}",
                              style: AppTextStyles.font10GreyRegular,
                            ),
                          ],
                        ),
                      ),

                      // Arrow
                      Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Image.asset(
                          AppAssets.arrowRight,
                          width: 20.w,
                          height: 18.h,
                        ),
                      ),
                    ],
                  ),

                  // Status Badge
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          approval.status,
                        ).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        approval.status,
                        style: AppTextStyles.font10GreyRegular.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(approval.status),
                          fontSize: 9.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "approved":
        return Colors.green;
      case "under review":
        return const Color(0xFFFFC888);
      case "rejected":
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}
