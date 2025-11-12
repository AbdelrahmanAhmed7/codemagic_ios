import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:mediconsult/features/approval_request/presentation/cubit/approvals_cubit.dart';
import 'package:mediconsult/features/approval_request/presentation/cubit/approvals_state.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/approval_empty_state.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/approval_list_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:mediconsult/shared/widgets/segmented_tabs.dart';

// ignore_for_file: deprecated_member_use

class ApprovalHistoryScreen extends StatefulWidget {
  const ApprovalHistoryScreen({super.key});

  @override
  State<ApprovalHistoryScreen> createState() => _ApprovalHistoryScreenState();
}

class _ApprovalHistoryScreenState extends State<ApprovalHistoryScreen> {
  final ScrollController _controller = ScrollController();
  int _currentTab = 0;
  Timer? _scrollTimer;
  bool _isLoadingMore = false;

  // Showcase keys
  final GlobalKey _tabsKey = GlobalKey();
  final GlobalKey _fabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ApprovalsCubit>().load(
      lang: context.locale.languageCode,
      status: 'All',
      reset: true,
    );
  }

  void _onScroll() {
    if (!_controller.hasClients || _isLoadingMore) return;
    final position = _controller.position;
    // Load more when 85% scrolled (instead of 90% for better UX)
    if (position.pixels >= position.maxScrollExtent * 0.85) {
      // Debounce scroll events
      _scrollTimer?.cancel();
      _scrollTimer = Timer(const Duration(milliseconds: 300), () {
        if (mounted && !_isLoadingMore) {
          _isLoadingMore = true;
          context
              .read<ApprovalsCubit>()
              .loadMore(lang: context.locale.languageCode)
              .then((_) {
                _isLoadingMore = false;
              });
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
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
                title: 'approval_history.title'.tr(),
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
                            description: 'Swipe or tap to filter approvals',
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
                                context.read<ApprovalsCubit>().changeStatus(
                                  apiStatus[i],
                                  lang: context.locale.languageCode,
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: BlocBuilder<ApprovalsCubit, ApprovalsState>(
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
                                          approvals,
                                          pagination,
                                          status,
                                          loadingMore,
                                        ) {
                                          if (approvals.isEmpty) {
                                            return const ApprovalEmptyState();
                                          }
                                          return ApprovalListView(
                                            approvals: approvals,
                                            controller: _controller,
                                            hasNextPage: pagination.hasNextPage,
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
          description: 'Tap to create a new approval request',
          child: FloatingActionButton(
            onPressed: () {
              context.push('/approval-request');
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(44.r),
            ),
            backgroundColor: AppColors.primaryClr,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
