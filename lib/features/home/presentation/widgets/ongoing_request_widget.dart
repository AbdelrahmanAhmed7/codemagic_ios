import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/home/data/home_response_model.dart';
import 'package:mediconsult/features/home/presentation/widgets/ongoing_request_card.dart';

class OngoingRequestWidget extends StatelessWidget {
  final HomeData data;

  const OngoingRequestWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Filter to show only reviewing approvals and take last 3
    final approvals = data.approvals
        .where((approval) => approval.status.toLowerCase() == 'reviewing')
        .toList()
        .reversed
        .take(3)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'home.ongoing_requests'.tr(),
              style: AppTextStyles.font16BlackMedium(context).copyWith(
                fontWeight: FontWeight.w600,),
            ),
            GestureDetector(
              onTap: () {
                context.push('/approval-history');
              },
              child: Text(
                'home.see_all'.tr(),
                style: AppTextStyles.font14PrimaryMedium(
                  context,
                ).copyWith(fontSize: 12.sp),
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
                'home',
                style: AppTextStyles.font12GreyRegular(context),
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
              // Performance optimizations
              cacheExtent: 500,
              addAutomaticKeepAlives: true,
              addRepaintBoundaries: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final approval = approvals[index];
                return SizedBox(
                  width: 300.w,
                  child: OngoingRequestCard(approval: approval),
                );
              },
            ),
          ),
      ],
    );
  }
}
