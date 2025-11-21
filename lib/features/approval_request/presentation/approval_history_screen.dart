import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:mediconsult/features/approval_request/presentation/cubit/approvals_cubit.dart';
import 'package:mediconsult/features/approval_request/presentation/cubit/approvals_state.dart';
import 'package:mediconsult/features/approval_request/data/approvals_models.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/approval_details_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';

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
          context.read<ApprovalsCubit>().loadMore(
            lang: context.locale.languageCode,
          ).then((_) {
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
    return Scaffold(
      backgroundColor: AppColors.lightGreyClr,
      body: SafeArea(
        child: Column(
          children: [
            PageHeader(title: 'approval_history.title'.tr(), backPath: '/home'),
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
                        _buildTabs(),
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
                                              approvals.length +
                                              (pagination.hasNextPage ? 1 : 0),
                                          separatorBuilder: (_, __) =>
                                              SizedBox(height: 12.h),
                                          itemBuilder: (context, index) {
                                            if (index >= approvals.length) {
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
                                            return _ApprovalCard(
                                              key: ValueKey(
                                                approvals[index].id,
                                              ),
                                              item: approvals[index],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/approval-request');
        },
        backgroundColor: AppColors.primaryClr,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTabs() {
    final tabs = [
      'approval_history.tabs.all'.tr(),
      'approval_history.tabs.pending'.tr(),
      'approval_history.tabs.approved'.tr(),
      'approval_history.tabs.rejected'.tr(),
    ];

    final apiStatus = ['All', 'Pending', 'Approved', 'Rejected'];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (i) {
            final selected = _currentTab == i;
            return GestureDetector(
              onTap: () {
                setState(() => _currentTab = i);
                context.read<ApprovalsCubit>().changeStatus(
                  apiStatus[i],
                  lang: context.locale.languageCode,
                );
              },
              child: Padding(
                padding: EdgeInsets.only(right: 22.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tabs[i],
                      style: selected
                          ? AppTextStyles.font14BlueMedium(context)
                          : AppTextStyles.font14GreyRegular(context),
                    ),
                    if (selected)
                      Container(
                        margin: EdgeInsets.only(top: 6.h),
                        height: 2.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                          color: AppColors.blueClr,
                          borderRadius: BorderRadius.circular(1.r),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
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
          Image.asset(AppAssets.emptyState, width: 250.w, height: 200.h),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: AppTextStyles.font14BlackMedium(context),
                children: [
                  TextSpan(text: 'approval_history.empty_state'.tr()),
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
                  TextSpan(text: 'approval_history.to_request_approval'.tr()),
                ],
              ),
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

class _ApprovalCard extends StatelessWidget {
  final ApprovalItem item;
  const _ApprovalCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _getStatusColor(item.statusChar);
    final Color backgroundColor = _getBackgroundColorForStatus(item.statusChar);
    final String statusLabel = _getStatusLabel(item.statusChar);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(12.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // logo
          Container(
            width: 69.w,
            height: 69.w,
            decoration: BoxDecoration(
              color: AppColors.primaryClr,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child:
                (item.providerLogo != null &&
                    item.providerLogo!.isNotEmpty &&
                    item.providerLogo!.startsWith('http'))
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: CachedNetworkImage(
                      imageUrl: item.providerLogo!,
                      fit: BoxFit.cover,
                      memCacheWidth: 138,
                      memCacheHeight: 138,
                      maxWidthDiskCache: 138,
                      maxHeightDiskCache: 138,
                      placeholder: (context, url) => Center(
                        child: SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Image.asset(AppAssets.logo, fit: BoxFit.contain),
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Image.asset(AppAssets.logo, fit: BoxFit.contain),
                  ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // رقم الطلب + الحالة
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${'approval_history.request_number'.tr()}${item.approvalNumber}',
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
                      '${'approval_history.date'.tr()}${item.date}',
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
                      '${'approval_history.time'.tr()}${item.time}',
                      style: AppTextStyles.font10GreyRegular(context),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ApprovalDetailsBottomSheet.show(context, item);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'approval_history.view_details'.tr(),
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

  static Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'A':
        return const Color(0xFF349859);
      case 'R':
        return const Color(0xFFB92828);
      case 'P':
      default:
        return const Color(0xFF999999);
    }
  }

  static Color _getBackgroundColorForStatus(String status) {
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

  static String _getStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'A':
        return 'approval_history.status.approved'.tr();
      case 'R':
        return 'approval_history.status.rejected'.tr();
      case 'P':
      default:
        return 'approval_history.status.pending'.tr();
    }
  }
}
