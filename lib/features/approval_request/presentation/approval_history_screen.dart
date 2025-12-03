import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/approval_request/presentation/cubit/approvals_cubit.dart';
import 'package:mediconsult/features/approval_request/presentation/cubit/approvals_state.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/approval_empty_state.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/approval_list_view.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:mediconsult/shared/widgets/segmented_tabs.dart';
import 'package:mediconsult/shared/widgets/custom_showcase.dart';

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
  
  // Showcase state
  int _showcaseIndex = -1;

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

  void _startShowcase() {
    setState(() {
      _showcaseIndex = 0;
    });
  }

  void _nextShowcase() {
    if (_showcaseIndex < _showcaseKeys.length - 1) {
      setState(() {
        _showcaseIndex++;
      });
    } else {
      _dismissShowcase();
    }
  }

  void _dismissShowcase() {
    setState(() {
      _showcaseIndex = -1;
    });
  }

  List<GlobalKey> get _showcaseKeys => [
        _tabsKey,
        _fabKey,
      ];

  List<String> get _showcaseDescriptions => [
        'tutorial.approval_history.swipe'.tr(),
        'tutorial.approval_history.fab'.tr(),
      ];

  @override
  Widget build(BuildContext context) {
    return CustomShowcaseOverlay(
      targetKeys: _showcaseKeys,
      descriptions: _showcaseDescriptions,
      currentIndex: _showcaseIndex,
      onNext: _nextShowcase,
      onDismiss: _dismissShowcase,
      child: Scaffold(
        backgroundColor: AppColors.lightGreyClr,
        body: SafeArea(
          child: Column(
            children: [
              PageHeader(
                title: 'approval_history.title'.tr(),
                backPath: '/home',
                onHelp: () {
                  _startShowcase();
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
                          CustomShowcase(
                            key: _tabsKey,
                            targetKey: _tabsKey,
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
        floatingActionButton: CustomShowcase(
          key: _fabKey,
          targetKey: _fabKey,
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
