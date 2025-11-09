import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:mediconsult/features/refund/presentation/cubit/refunds_cubit.dart';
import 'package:mediconsult/features/refund/presentation/cubit/refunds_state.dart';
import 'package:mediconsult/features/refund/presentation/widgets/refund_card.dart';
import 'package:mediconsult/features/refund/presentation/widgets/refund_empty_state.dart';
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
                                            return const RefundEmptyState();
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
                                              return RefundCard(
                                                key: ValueKey(refunds[index].id),
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
}
