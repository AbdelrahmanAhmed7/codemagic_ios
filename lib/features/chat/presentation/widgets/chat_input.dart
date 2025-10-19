import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSendMessage;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.lightGreyClr,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.r),
          bottomRight: Radius.circular(16.r),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.whiteClr,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Message...',
                  hintStyle: AppTextStyles.font12GreyRegular,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                onSubmitted: onSendMessage,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.lightGreyClr,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Icon(
              Icons.attach_file,
              color: AppColors.greyClr,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () => onSendMessage(controller.text),
            child: Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: AppColors.primaryClr,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send,
                color: AppColors.whiteClr,
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
