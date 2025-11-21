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
      crossAxisAlignment: CrossAxisAlignment.end,
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
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isUser ? AppColors.primaryClr : AppColors.lightGreyClr,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
                bottomLeft: Radius.circular(isUser ? 16.r : 4.r),
                bottomRight: Radius.circular(isUser ? 4.r : 16.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: isUser 
                      ? AppTextStyles.font14WhiteMedium(context)
                      : AppTextStyles.font14BlackMedium(context),
                ),
                SizedBox(height: 4.h),
                Text(
                  _formatTime(timestamp),
                  style: isUser
                      ? AppTextStyles.font10WhiteRegular(context).copyWith(
                          color: AppColors.whiteClr.withValues(alpha: 0.7),
                        )
                      : AppTextStyles.font10GreyRegular(context),
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
