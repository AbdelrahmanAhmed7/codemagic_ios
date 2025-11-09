import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/features/approval_request/data/approvals_models.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/approval_card.dart';

class ApprovalListView extends StatelessWidget {
  final List<ApprovalItem> approvals;
  final ScrollController controller;
  final bool hasNextPage;

  const ApprovalListView({
    super.key,
    required this.approvals,
    required this.controller,
    required this.hasNextPage,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      physics: const BouncingScrollPhysics(),
      itemCount: approvals.length + (hasNextPage ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        if (index >= approvals.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        return ApprovalCard(
          key: ValueKey(approvals[index].id),
          item: approvals[index],
        );
      },
    );
  }
}
