import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUser) ...[
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: AppColors.lightGreyClr,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.support_agent,
              color: AppColors.greyClr,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 8.w),
        ],
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isUser ? AppColors.primaryClr : AppColors.lightGreyClr,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: isUser 
                      ? AppTextStyles.font12WhiteRegular
                      : AppTextStyles.font12BlackRegular,
                ),
                SizedBox(height: 4.h),
                Text(
                  _formatTime(timestamp),
                  style: isUser
                      ? AppTextStyles.font10WhiteRegular.copyWith(
                          color: AppColors.whiteClr.withValues(alpha: 0.7),
                        )
                      : AppTextStyles.font10GreyRegular,
                ),
              ],
            ),
          ),
        ),
        if (isUser) ...[
          SizedBox(width: 8.w),
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: AppColors.primaryClr,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: AppColors.whiteClr,
              size: 18.sp,
            ),
          ),
        ],
      ],
    );
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
