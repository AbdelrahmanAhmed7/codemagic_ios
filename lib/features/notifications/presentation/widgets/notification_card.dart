import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/notifications/data/notification_models.dart';
import 'package:mediconsult/core/utils/notification_action_handler.dart';

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
    final hasAction = NotificationActionHandler.hasAction(item);

    return GestureDetector(
      onTap: () async {
        // Handle notification action first
        if (hasAction) {
          await NotificationActionHandler.handleNotificationTap(context, item);
        }
        
        // Mark as read after action completes
        if (!item.isRead && onMarkRead != null) {
          onMarkRead!();
        }
      },
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
    final hasValidImage = item.imageUrl != null && 
                          item.imageUrl!.trim().isNotEmpty &&
                          _isValidImageUrl(item.imageUrl!);
    
    // Debug logging
    if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
      debugPrint('📸 Notification Image URL: ${item.imageUrl}');
      debugPrint('✅ Valid Image: $hasValidImage');
    }
    
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: hasValidImage
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: CachedNetworkImage(
                imageUrl: item.imageUrl!.trim(),
                fit: BoxFit.cover,
                memCacheWidth: 96,
                memCacheHeight: 96,
                maxWidthDiskCache: 96,
                maxHeightDiskCache: 96,
                httpHeaders: const {
                  'Accept': 'image/*',
                },
                fadeInDuration: const Duration(milliseconds: 300),
                fadeOutDuration: const Duration(milliseconds: 100),
                placeholder: (context, url) => Container(
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) {
                  debugPrint('❌ Failed to load image: $url');
                  debugPrint('❌ Error: $error');
                  return Container(
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 24.sp,
                    ),
                  );
                },
              ),
            )
          : Icon(icon, color: iconColor, size: 24.sp),
    );
  }
  
  bool _isValidImageUrl(String url) {
    try {
      final trimmedUrl = url.trim();
      if (trimmedUrl.isEmpty) return false;
      
      final lowerUrl = trimmedUrl.toLowerCase();
      
      // Check if it's a valid HTTP/HTTPS URL
      if (!lowerUrl.startsWith('http://') && !lowerUrl.startsWith('https://')) {
        return false;
      }
      
      // Firebase Storage URLs are always valid
      if (lowerUrl.contains('firebasestorage.googleapis.com') ||
          lowerUrl.contains('firebasestorage.app')) {
        return true;
      }
      
      // Check for common image extensions
      final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp', '.svg'];
      for (final ext in imageExtensions) {
        if (lowerUrl.endsWith(ext)) return true;
      }
      
      // Check for image-related keywords in URL
      if (lowerUrl.contains('/image/') ||
          lowerUrl.contains('/images/') ||
          lowerUrl.contains('/img/') ||
          lowerUrl.contains('/photo/') ||
          lowerUrl.contains('/photos/') ||
          lowerUrl.contains('/picture/') ||
          lowerUrl.contains('/pictures/')) {
        return true;
      }
      
      // Check for query parameters that indicate image
      if (lowerUrl.contains('image=') || lowerUrl.contains('img=')) {
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('❌ Error validating image URL: $e');
      return false;
    }
  }

  Widget _buildHeader(BuildContext context) {
    final categoryLabel = _getCategoryLabel();
    final accentColor = _getIconColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                categoryLabel,
                style: AppTextStyles.font10GreyRegular(context).copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              item.time,
              style: AppTextStyles.font10GreyRegular(context),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          item.title,
          style: AppTextStyles.font14BlackMedium(context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
    // 1) إشعار تعطيل / تسجيل خروج
    if (item.hasDataKeyValue('is_disable', '1')) {
      return Icons.person_off;
    }

    // 2) إشعار خاص بالـ Refund
    if (item.hasDataKeyValue('is_refund', '1')) {
      return Icons.receipt_long;
    }

    // 3) إشعار موافقة / Approval (طلب أو موافقة صادرة)
    final approvalId = item.getDataValue('approval_id');
    final requestId = item.getDataValue('request_id');
    final isApproved = item.hasDataKeyValue('is_approved', '1');
    final hasApprovalOrRequest = (approvalId != null &&
            approvalId.isNotEmpty &&
            approvalId != '0') ||
        (requestId != null && requestId.isNotEmpty && requestId != '0');

    if (hasApprovalOrRequest || isApproved) {
      return Icons.check_circle;
    }

    // 4) fallback: حسب نص الرسالة القديمة
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

  String _getCategoryLabel() {
    if (item.hasDataKeyValue('is_disable', '1')) {
      return 'Account';
    }
    if (item.hasDataKeyValue('is_refund', '1')) {
      return 'Refund';
    }

    final approvalId = item.getDataValue('approval_id');
    final requestId = item.getDataValue('request_id');
    final isApproved = item.hasDataKeyValue('is_approved', '1');
    final hasApprovalOrRequest = (approvalId != null &&
            approvalId.isNotEmpty &&
            approvalId != '0') ||
        (requestId != null && requestId.isNotEmpty && requestId != '0');

    if (hasApprovalOrRequest || isApproved) {
      return 'Approval';
    }

    return 'Notification';
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