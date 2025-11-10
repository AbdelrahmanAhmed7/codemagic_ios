import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/notifications/data/notification_models.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback? onMarkRead;
  
  const NotificationCard({
    super.key,
    required this.item,
    this.onMarkRead,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = _getIconColor();
    final icon = _getIcon();

    return GestureDetector(
      onTap: !item.isRead && onMarkRead != null ? onMarkRead : null,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: item.isRead ? AppColors.whiteClr : const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: item.isRead
                ? AppColors.greyClr.withValues(alpha: 0.1)
                : AppColors.primaryClr.withValues(alpha: 0.2),
            width: item.isRead ? 1 : 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!item.isRead) _buildUnreadIndicator(),
            _buildIconOrImage(context, icon, iconColor),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  SizedBox(height: 4.h),
                  _buildBody(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnreadIndicator() {
    return Container(
      width: 8.w,
      height: 8.w,
      margin: EdgeInsets.only(top: 6.h, right: 6.w),
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildIconOrImage(BuildContext context, IconData icon, Color iconColor) {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: (item.imageUrl != null &&
              item.imageUrl!.isNotEmpty &&
              item.imageUrl!.startsWith('http'))
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
          : Icon(icon, color: iconColor, size: 24.sp),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
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
    );
  }

  Widget _buildBody(BuildContext context) {
    return Text(
      item.body,
      style: AppTextStyles.font12GreyRegular(context).copyWith(
        color: item.isRead
            ? AppColors.greyClr
            : AppColors.blackClr.withValues(alpha: 0.8),
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

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
}
