import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class NoteTextField extends StatefulWidget {
  const NoteTextField({super.key, required this.maxLength});
  final int maxLength;

  @override
  State<NoteTextField> createState() => _NoteTextFieldState();
}

class _NoteTextFieldState extends State<NoteTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.whiteClr,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Color(0xffECECEC)),
            boxShadow: [
              BoxShadow(
                color: AppColors.greyClr.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            autofocus: false,
            maxLines: 3,
            maxLength: widget.maxLength,
            decoration: InputDecoration(
              counterText: '',
              hintText: 'Enter Note',
              hintStyle: AppTextStyles.font14GreyRegular,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12.r),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Maximum ${widget.maxLength} characters',
          style: AppTextStyles.font10GreyRegular.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}


