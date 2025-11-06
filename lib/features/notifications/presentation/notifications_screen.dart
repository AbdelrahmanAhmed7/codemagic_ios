import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:mediconsult/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:mediconsult/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:mediconsult/features/notifications/data/notification_models.dart';

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

  String _tr(BuildContext context, String key, String fallback) {
    final translated = key.tr();
    return translated == key ? fallback : translated;
  }

  // Group notifications by date
  Map<String, List<NotificationItem>> _groupByDate(List<NotificationItem> notifications) {
    final Map<String, List<NotificationItem>> grouped = {};
    for (var notification in notifications) {
      if (!grouped.containsKey(notification.date)) {
        grouped[notification.date] = [];
      }
      grouped[notification.date]!.add(notification);
    }
    return grouped;
  }

  // Format date to show day name and date
  String _formatDateHeader(String dateStr) {
    try {
      // Parse date supporting both "DD-MM-YYYY" and "YYYY-MM-DD"
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        int day;
        int month;
        int year;
        if (parts[0].length == 4) {
          // YYYY-MM-DD
          year = int.parse(parts[0]);
          month = int.parse(parts[1]);
          day = int.parse(parts[2]);
        } else {
          // DD-MM-YYYY
          day = int.parse(parts[0]);
          month = int.parse(parts[1]);
          year = int.parse(parts[2]);
        }
        final date = DateTime(year, month, day);
        
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final yesterday = today.subtract(const Duration(days: 1));
        
        if (date == today) {
          return _tr(context, 'notifications.today', 'Today');
        } else if (date == yesterday) {
          return _tr(context, 'notifications.yesterday', 'Yesterday');
        } else {
          // Format: "Thursday, 23 Oct 2024"
          final weekdays = [
            _tr(context, 'notifications.days.monday', 'Monday'),
            _tr(context, 'notifications.days.tuesday', 'Tuesday'),
            _tr(context, 'notifications.days.wednesday', 'Wednesday'),
            _tr(context, 'notifications.days.thursday', 'Thursday'),
            _tr(context, 'notifications.days.friday', 'Friday'),
            _tr(context, 'notifications.days.saturday', 'Saturday'),
            _tr(context, 'notifications.days.sunday', 'Sunday'),
          ];
          final months = [
            _tr(context, 'notifications.months.jan', 'Jan'),
            _tr(context, 'notifications.months.feb', 'Feb'),
            _tr(context, 'notifications.months.mar', 'Mar'),
            _tr(context, 'notifications.months.apr', 'Apr'),
            _tr(context, 'notifications.months.may', 'May'),
            _tr(context, 'notifications.months.jun', 'Jun'),
            _tr(context, 'notifications.months.jul', 'Jul'),
            _tr(context, 'notifications.months.aug', 'Aug'),
            _tr(context, 'notifications.months.sep', 'Sep'),
            _tr(context, 'notifications.months.oct', 'Oct'),
            _tr(context, 'notifications.months.nov', 'Nov'),
            _tr(context, 'notifications.months.dec', 'Dec'),
          ];
          final weekday = weekdays[date.weekday - 1];
          final monthName = months[date.month - 1];
          return '$weekday, ${date.day} $monthName ${date.year}';
        }
      }
    } catch (e) {
      // Fallback to original date string
    }
    return dateStr;
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
                          loaded: (notifications, totalCount, currentPage, totalPages, hasNextPage, loadingMore) {
                            if (notifications.isEmpty) {
                              return Center(
                                child: Text(
                                  'notifications.no_notifications'.tr(),
                                  style: AppTextStyles.font14GreyRegular(context),
                                ),
                              );
                            }

                            // Group notifications by date
                            final groupedNotifications = _groupByDate(notifications);
                            final dates = groupedNotifications.keys.toList();

                            return RefreshIndicator(
                              onRefresh: () => context.read<NotificationsCubit>().refresh(lang: context.locale.languageCode),
                              child: ListView.builder(
                                controller: _controller,
                                physics: const AlwaysScrollableScrollPhysics(),
                                cacheExtent: 1000,
                                addAutomaticKeepAlives: false,
                                addRepaintBoundaries: false,
                                padding: EdgeInsets.all(16.w),
                                itemCount: dates.length + (hasNextPage ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index >= dates.length) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(12),
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    );
                                  }

                                  final date = dates[index];
                                  final dateNotifications = groupedNotifications[date]!;

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Date Header
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 12.h, top: index == 0 ? 0 : 16.h),
                                        child: Text(
                                          _formatDateHeader(date),
                                          style: AppTextStyles.font14BlackMedium(context),
                                        ),
                                      ),
                                      // Notifications for this date
                                      ...dateNotifications.map((notification) {
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: 12.h),
                                          child: RepaintBoundary(
                                            child: _NotificationCard(
                                              key: ValueKey(notification.id),
                                              item: notification,
                                              onMarkRead: notification.isRead
                                                  ? null
                                                  : () => context.read<NotificationsCubit>().markAsRead(
                                                        lang: context.locale.languageCode,
                                                        notificationId: notification.id,
                                                      ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  );
                                },
                              ),
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

class _NotificationCard extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback? onMarkRead;
  const _NotificationCard({super.key, required this.item, this.onMarkRead});

  IconData _getIcon() {
    final body = item.body.toLowerCase();
    if (body.contains('appointment') || body.contains('موعد')) {
      return Icons.calendar_today;
    } else if (body.contains('approval') || body.contains('موافقة')) {
      return Icons.check_circle;
    } else if (body.contains('medicine') || body.contains('دواء')) {
      return Icons.medication;
    }
    return Icons.notifications;
  }

  Color _getIconColor() {
    final body = item.body.toLowerCase();
    if (body.contains('approved') || body.contains('success')) {
      return Colors.green;
    } else if (body.contains('rejected') || body.contains('رفض')) {
      return Colors.red;
    } else if (body.contains('reviewing') || body.contains('جار العمل')) {
      return Colors.orange;
    }
    return AppColors.primaryClr;
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = _getIconColor();
    final icon = _getIcon();

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: item.isRead ? AppColors.whiteClr : const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: item.isRead ? AppColors.greyClr.withValues(alpha: 0.1) : AppColors.primaryClr.withValues(alpha: 0.2),
          width: item.isRead ? 1 : 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unread indicator dot
          if (!item.isRead) ...[
            Container(
              width: 6.w,
              height: 6.w,
              margin: EdgeInsets.only(top: 6.h, right: 6.w),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            ),
          ],
          // Icon or Image
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: (item.imageUrl != null && item.imageUrl!.isNotEmpty && item.imageUrl!.startsWith('http'))
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl!,
                      fit: BoxFit.cover,
                      memCacheWidth: 96,
                      memCacheHeight: 96,
                      maxWidthDiskCache: 96,
                      maxHeightDiskCache: 96,
                      placeholder: (context, url) => Center(
                        child: SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        icon,
                        color: iconColor,
                        size: 24.sp,
                      ),
                    ),
                  )
                : Icon(
                    icon,
                    color: iconColor,
                    size: 24.sp,
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
                        item.title,
                        style: AppTextStyles.font14BlackMedium(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      item.time,
                      style: AppTextStyles.font10GreyRegular(context),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  item.body,
                  style: AppTextStyles.font12GreyRegular(context).copyWith(
                    color: item.isRead ? AppColors.greyClr : AppColors.blackClr.withValues(alpha: 0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!item.isRead && onMarkRead != null) ...[
                  SizedBox(height: 8.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: onMarkRead,
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: AppColors.primaryClr.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.primaryClr.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 16.sp,
                              color: AppColors.primaryClr,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'notifications.mark_read'.tr(),
                              style: AppTextStyles.font12GreyRegular(context).copyWith(
                                color: AppColors.primaryClr,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
