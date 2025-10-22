import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/approval_request/presentation/cubit/approvals_cubit.dart';
import 'package:mediconsult/features/approval_request/presentation/cubit/approvals_state.dart';
import 'package:mediconsult/features/approval_request/data/approvals_models.dart';

class ApprovalHistorySection extends StatefulWidget {
  const ApprovalHistorySection({super.key});

  @override
  State<ApprovalHistorySection> createState() => _ApprovalHistorySectionState();
}

class _ApprovalHistorySectionState extends State<ApprovalHistorySection> {
  final ScrollController _controller = ScrollController();
  int _currentTab = 0; // 0 All, 1 Pending, 2 Approved, 3 Rejected

  @override
  void initState() {
    super.initState();
    context.read<ApprovalsCubit>().load(lang: 'en', status: 'All', reset: true);
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final position = _controller.position;
    if (position.pixels >= position.maxScrollExtent * 0.9) {
      context.read<ApprovalsCubit>().loadMore(lang: 'en');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTabs(),
        SizedBox(height: 12.h),
        BlocBuilder<ApprovalsCubit, ApprovalsState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              failed: (message) => Center(
                child: Text(message, style: AppTextStyles.font14GreyRegular),
              ),
              loaded: (approvals, pagination, status, loadingMore) {
                if (approvals.isEmpty) {
                  return const SizedBox.shrink(); // Don't show empty state, just hide the section
                }
                return ListView.separated(
                  controller: _controller,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  cacheExtent: 500,
                  addAutomaticKeepAlives: true,
                  addRepaintBoundaries: true,
                  itemCount: approvals.length + (pagination.hasNextPage ? 1 : 0),
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    if (index >= approvals.length) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ));
                    }
                    return RepaintBoundary(
                      key: ValueKey(approvals[index].id),
                      child: _ApprovalCard(item: approvals[index]),
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildTabs() {
    final tabs = ['All', 'Pending', 'Approved', 'Rejected'];
    return Row(
      children: List.generate(tabs.length, (i) {
        final selected = _currentTab == i;
        return GestureDetector(
          onTap: () {
            setState(() => _currentTab = i);
            final status = switch (i) { 0 => 'All', 1 => '0', 2 => '1', _ => '2' };
            context.read<ApprovalsCubit>().changeStatus(status, lang: 'en');
          },
          child: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tabs[i],
                  style: selected ? AppTextStyles.font14BlueMedium : AppTextStyles.font14GreyRegular,
                ),
                if (selected)
                  Container(
                    margin: EdgeInsets.only(top: 6.h),
                    height: 2.h,
                    width: 24.w,
                    color: AppColors.primaryClr,
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _ApprovalCard extends StatefulWidget {
  final ApprovalItem item;
  const _ApprovalCard({required this.item});

  @override
  State<_ApprovalCard> createState() => _ApprovalCardState();
}

class _ApprovalCardState extends State<_ApprovalCard> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Color statusColor = _statusColor(widget.item.statusChar);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteClr,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(color: AppColors.greyClr.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0,4)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: AppColors.lightGreyClr,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: const Icon(Icons.local_hospital, color: AppColors.greyClr),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Request Number: ${widget.item.approvalNumber}', style: AppTextStyles.font12BlueMedium),
                  SizedBox(height: 6.h),
                  Row(children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.greyClr),
                    SizedBox(width: 6.w),
                    Text('Date: ${widget.item.date.split('T').first}', style: AppTextStyles.font12GreyRegular),
                  ]),
                  SizedBox(height: 4.h),
                  Row(children: [
                    const Icon(Icons.access_time, size: 14, color: AppColors.greyClr),
                    SizedBox(width: 6.w),
                    Text('Time: ${widget.item.time}', style: AppTextStyles.font12GreyRegular),
                  ]),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(_statusLabel(widget.item.statusChar), style: AppTextStyles.font10GreyRegular.copyWith(color: statusColor)),
            ),
          ],
        ),
      ),
    );
  }

  static Color _statusColor(String s) {
    switch(s.toUpperCase()) {
      case 'A': return const Color(0xFF22C55E); // green
      case 'R': return const Color(0xFFF43F5E); // red
      default: return const Color(0xFF94A3B8); // gray
    }
  }

  static String _statusLabel(String s) {
    switch(s.toUpperCase()) {
      case 'A': return 'Approved';
      case 'R': return 'Rejected';
      default: return 'Pending';
    }
  }
}


