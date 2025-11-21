import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:mediconsult/features/refund/presentation/cubit/refunds_cubit.dart';
import 'package:mediconsult/features/refund/presentation/cubit/refunds_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:mediconsult/shared/widgets/segmented_tabs.dart';
// ignore_for_file: deprecated_member_use

class RefundHistoryScreen extends StatefulWidget {
  const RefundHistoryScreen({super.key});

  @override
  State<RefundHistoryScreen> createState() => _RefundHistoryScreenState();
}

class _RefundHistoryScreenState extends State<RefundHistoryScreen> {
  final ScrollController _controller = ScrollController();
  int _currentTab = 0; // 0 All, 1 Pending, 2 Approved, 3 Rejected

  final GlobalKey _tabsKey = GlobalKey();
  final GlobalKey _fabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    context.read<RefundsCubit>().load(status: 'All', reset: true);
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final position = _controller.position;
    if (position.pixels >= position.maxScrollExtent * 0.9) {
      context.read<RefundsCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (context) => Scaffold(
        backgroundColor: AppColors.lightGreyClr,
        body: SafeArea(
          child: Column(
            children: [
            PageHeader(
                title: 'refund_history.title'.tr(),
                backPath: '/home',
              onHelp: () {
                ShowCaseWidget.of(context).startShowCase([_tabsKey, _fabKey]);
              },
              ),
              Expanded(
                child: Transform.translate(
                  offset: Offset(0, -20.h),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.whiteClr,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.greyClr.withValues(alpha: 0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 16.h),
                          Showcase(
                            key: _tabsKey,
                            description: 'Tap to filter refund requests',
                            child: SegmentedTabs(
                              labels: [
                                'approval_history.tabs.all'.tr(),
                                'approval_history.tabs.pending'.tr(),
                                'approval_history.tabs.approved'.tr(),
                                'approval_history.tabs.rejected'.tr(),
                              ],
                              selectedIndex: _currentTab,
                              onTap: (i) {
                                setState(() => _currentTab = i);
                                final apiStatus = [
                                  'All',
                                  'Pending',
                                  'Approved',
                                  'Rejected',
                                ];
                                context.read<RefundsCubit>().changeStatus(
                                  apiStatus[i],
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: BlocBuilder<RefundsCubit, RefundsState>(
                                builder: (context, state) {
                                  return state.when(
                                    initial: () => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    loading: () => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    failed: (message) => Center(
                                      child: Text(
                                        message,
                                        style: AppTextStyles.font14GreyRegular(
                                          context,
                                        ),
                                      ),
                                    ),
                                    loaded:
                                        (
                                          refunds,
                                          pagination,
                                          status,
                                          loadingMore,
                                        ) {
                                          if (refunds.isEmpty) {
                                            return _buildEmptyState();
                                          }
                                          return ListView.separated(
                                            controller: _controller,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            cacheExtent: 500,
                                            addAutomaticKeepAlives: true,
                                            addRepaintBoundaries: true,
                                            itemCount:
                                                refunds.length +
                                                (pagination.hasNextPage
                                                    ? 1
                                                    : 0),
                                            separatorBuilder: (_, __) =>
                                                SizedBox(height: 12.h),
                                            itemBuilder: (context, index) {
                                              if (index >= refunds.length) {
                                                return const Center(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(12),
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                  ),
                                                );
                                              }
                                              return _RefundCard(
                                                key: ValueKey(
                                                  refunds[index].id,
                                                ),
                                                item: refunds[index],
                                              );
                                            },
                                          );
                                        },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      floatingActionButton: Showcase(
          key: _fabKey,
          description: 'Create a new refund request',
          child: FloatingActionButton(
            onPressed: () {
              context.push('/refund-request');
            },
            backgroundColor: AppColors.primaryClr,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 50.h),
          Image.asset(AppAssets.refundEmpty, width: 250.w, height: 200.h),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                Text(
                  'refund_history.empty_state_title'.tr(),
                  style: AppTextStyles.font20BlackSemiBold(context),
                ),
                SizedBox(height: 8.h),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTextStyles.font14BlackMedium(context),
                    children: [
                      TextSpan(text: 'refund_history.empty_state'.tr()),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF2563EB),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      TextSpan(text: 'refund_history.to_request_refund'.tr()),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Image.asset(AppAssets.arrow, width: 130.w, height: 130.h),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

class _RefundCard extends StatelessWidget {
  final RefundItem item;
  const _RefundCard({super.key, required this.item});

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
          Container(
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
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${'refund_history.request_number'.tr()}${item.requestNumber}',
                        style: AppTextStyles.font10GreyRegular(context),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 3.h,
                      ),
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
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14.sp,
                      color: AppColors.blueClr,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      '${'refund_history.date'.tr()}${item.date}',
                      style: AppTextStyles.font10GreyRegular(context),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14.sp,
                      color: AppColors.blueClr,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      '${'refund_history.time'.tr()}${item.time}',
                      style: AppTextStyles.font10GreyRegular(context),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Align(
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
                ),
              ],
            ),
          ),
        ],
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
