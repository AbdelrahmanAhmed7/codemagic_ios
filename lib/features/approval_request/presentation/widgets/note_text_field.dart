import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class NoteTextField extends StatefulWidget {
  const NoteTextField({
    super.key, 
    required this.maxLength,
    this.controller,
  });
  final int maxLength;
  final TextEditingController? controller;

  @override
  State<NoteTextField> createState() => _NoteTextFieldState();
}

class _NoteTextFieldState extends State<NoteTextField> {
  late TextEditingController _controller;
  bool _isExternalController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _isExternalController = true;
    } else {
      _controller = TextEditingController();
      _isExternalController = false;
    }
  }

  @override
  void dispose() {
    if (!_isExternalController) {
      _controller.dispose();
    }
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
              hintStyle: AppTextStyles.font14GreyRegular(context),
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
          style: AppTextStyles.font10GreyRegular(context).copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}


