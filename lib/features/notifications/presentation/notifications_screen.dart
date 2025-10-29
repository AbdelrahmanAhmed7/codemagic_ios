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

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsCubit>().load(lang: 'en');
    });
  }

  void _onScroll() {
    if (_controller.position.pixels >= _controller.position.maxScrollExtent * 0.9) {
      context.read<NotificationsCubit>().loadMore(lang: 'en');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      // Parse date from format "30-07-2024"
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        final date = DateTime(year, month, day);
        
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final yesterday = today.subtract(const Duration(days: 1));
        
        if (date == today) {
          return 'Today';
        } else if (date == yesterday) {
          return 'Yesterday';
        } else {
          // Format: "Thursday, 23 Oct 2024"
          const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
          const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
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
            const PageHeader(title: 'Notification', backPath: '/home'),
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
                                  'No notifications',
                                  style: AppTextStyles.font14GreyRegular(context),
                                ),
                              );
                            }

                            // Group notifications by date
                            final groupedNotifications = _groupByDate(notifications);
                            final dates = groupedNotifications.keys.toList();

                            return RefreshIndicator(
                              onRefresh: () => context.read<NotificationsCubit>().refresh(lang: 'en'),
                              child: ListView.builder(
                                controller: _controller,
                                physics: const BouncingScrollPhysics(),
                                cacheExtent: 500,
                                addAutomaticKeepAlives: true,
                                addRepaintBoundaries: true,
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
  const _NotificationCard({super.key, required this.item});

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
        color: item.isRead ? AppColors.whiteClr : AppColors.primaryClr.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.greyClr.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  style: AppTextStyles.font12GreyRegular(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
