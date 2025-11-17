import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class NoteTextField extends StatefulWidget {
  const NoteTextField({
    super.key, 
    required this.maxLength,
    this.controller,
    this.onChanged,
    this.errorText,
    this.focusNode,
  });
  final int maxLength;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? errorText;
  final FocusNode? focusNode;

  @override
  State<NoteTextField> createState() => _NoteTextFieldState();
}

class _NoteTextFieldState extends State<NoteTextField> {
  late TextEditingController _controller;
  bool _isExternalController = false;

  // Custom formatter to prevent the weird behavior
  TextInputFormatter get _lengthFormatter => TextInputFormatter.withFunction(
    (oldValue, newValue) {
      // If new text is within limit, allow it
      if (newValue.text.length <= widget.maxLength) {
        return newValue;
      }
      
      // If exceeding limit, truncate to exact limit
      final truncated = newValue.text.substring(0, widget.maxLength);
      return TextEditingValue(
        text: truncated,
        selection: TextSelection.collapsed(offset: truncated.length),
      );
    },
  );

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
    
    // Add listener to ensure text never exceeds limit
    _controller.addListener(_enforceLimit);
  }

  void _enforceLimit() {
    if (_controller.text.length > widget.maxLength) {
      final truncated = _controller.text.substring(0, widget.maxLength);
      _controller.value = TextEditingValue(
        text: truncated,
        selection: TextSelection.collapsed(offset: truncated.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_enforceLimit);
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
            focusNode: widget.focusNode,
            autofocus: false,
            maxLines: 3,
            enableInteractiveSelection: true,
            onTapOutside: (_) {
              FocusScope.of(context).unfocus();
              SystemChannels.textInput.invokeMethod('TextInput.hide');
            },
            inputFormatters: [
              _lengthFormatter,
            ],
            onChanged: (value) {
              setState(() {});
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            decoration: InputDecoration(
              counterText: '', // Hide default counter
              hintText: 'approval_request.enter_note'.tr(),
              hintStyle: AppTextStyles.font14GreyRegular(context),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.errorText != null ? AppColors.errorClr : Color(0xffECECEC),
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.errorText != null ? AppColors.errorClr : Color(0xffECECEC),
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.errorText != null ? AppColors.errorClr : Color(0xffECECEC),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.errorText != null)
              Expanded(
                child: Text(
                  widget.errorText!,
                  style: AppTextStyles.font12GreyRegular(context).copyWith(
                    color: AppColors.errorClr,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            else
              const Spacer(),
            Text(
              '${_controller.text.length}/${widget.maxLength}',
              style: AppTextStyles.font10GreyRegular(context).copyWith(
                color: _controller.text.length > widget.maxLength 
                    ? AppColors.errorClr 
                    : AppColors.greyClr,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}