import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/notifications/data/notification_models.dart';
import 'package:mediconsult/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:mediconsult/features/notifications/presentation/widgets/notification_card.dart';
import 'package:mediconsult/features/notifications/presentation/widgets/notification_date_formatter.dart';

class NotificationsListView extends StatelessWidget {
  final List<NotificationItem> notifications;
  final ScrollController controller;
  final bool hasNextPage;
  final VoidCallback onRefresh;

  const NotificationsListView({
    super.key,
    required this.notifications,
    required this.controller,
    required this.hasNextPage,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return Center(
        child: Text(
          'notifications.no_notifications'.tr(),
          style: AppTextStyles.font14GreyRegular(context),
        ),
      );
    }

    final groupedNotifications = _groupByDate(notifications);
    final dates = groupedNotifications.keys.toList();

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        controller: controller,
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
              _buildDateHeader(context, date, index),
              ...dateNotifications.map((notification) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: NotificationCard(
                    key: ValueKey('${notification.id}_${notification.isSeen}'),
                    item: notification,
                    onMarkRead: notification.isRead
                        ? null
                        : () => context.read<NotificationsCubit>().markAsRead(
                              lang: context.locale.languageCode,
                              notificationId: notification.id,
                            ),
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDateHeader(BuildContext context, String date, int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, top: index == 0 ? 0 : 16.h),
      child: Text(
        NotificationDateFormatter.formatDateHeader(context, date),
        style: AppTextStyles.font14BlackMedium(context),
      ),
    );
  }

  Map<String, List<NotificationItem>> _groupByDate(
      List<NotificationItem> notifications) {
    final Map<String, List<NotificationItem>> grouped = {};
    for (var notification in notifications) {
      if (!grouped.containsKey(notification.date)) {
        grouped[notification.date] = [];
      }
      grouped[notification.date]!.add(notification);
    }
    return grouped;
  }
}
