import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:mediconsult/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:mediconsult/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:mediconsult/features/notifications/presentation/widgets/notifications_list_view.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ScrollController _controller = ScrollController();
  Locale? _lastLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLocale = context.locale;
    if (_lastLocale != currentLocale) {
      _lastLocale = currentLocale;
      context.read<NotificationsCubit>().load(lang: currentLocale.languageCode);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (_controller.position.pixels >= _controller.position.maxScrollExtent * 0.9) {
      context.read<NotificationsCubit>().loadMore(lang: context.locale.languageCode);
    }
  }

  @override
  void dispose() {
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
            PageHeader(title: 'notifications.title'.tr(), backPath: '/home'),
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
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () async {
                                await context.read<NotificationsCubit>().markAllAsRead(lang: context.locale.languageCode);
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('notifications.marked_all_read'.tr()),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              icon: Icon(Icons.done_all, size: 18.sp),
                              label: Text('notifications.mark_all_read'.tr()),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primaryClr,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: BlocBuilder<NotificationsCubit, NotificationsState>(
                      builder: (context, state) {
                        return state.when(
                          initial: () => const Center(child: CircularProgressIndicator()),
                          loading: () => const Center(child: CircularProgressIndicator()),
                          failed: (msg) => Center(
                            child: Text(msg, style: AppTextStyles.font14GreyRegular(context)),
                          ),
                          loaded: (notifications, totalCount, currentPage, totalPages, hasNextPage, loadingMore, updateCounter) {
                            return NotificationsListView(
                              notifications: notifications,
                              controller: _controller,
                              hasNextPage: hasNextPage,
                              onRefresh: () => context.read<NotificationsCubit>().refresh(lang: context.locale.languageCode),
                            );
                          },
                        );
                      },
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
    );
  }
}