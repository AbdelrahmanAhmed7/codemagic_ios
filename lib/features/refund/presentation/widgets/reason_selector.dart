import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';

class ReasonSelector extends StatefulWidget {
  const ReasonSelector({super.key});

  @override
  State<ReasonSelector> createState() => _ReasonSelectorState();
}

class _ReasonSelectorState extends State<ReasonSelector> {
  bool _isDropdownOpen = false;
  String? _selectedReason;

  final List<String> _reasons = [
    'Out of network',
    'Emergency case',
    'Not covered by insurance',
    'Partial coverage',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isDropdownOpen = !_isDropdownOpen;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.greyClr.withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedReason ?? 'Select reason',
                    style: _selectedReason != null
                        ? AppTextStyles.font14BlackMedium
                        : AppTextStyles.font14GreyRegular,
                  ),
                ),
                Icon(
                  _isDropdownOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.greyClr,
                  size: 24.w,
                ),
              ],
            ),
          ),
        ),
        if (_isDropdownOpen)
          Container(
            margin: EdgeInsets.only(top: 4.h),
            decoration: BoxDecoration(
              color: AppColors.whiteClr,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.greyClr.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: _reasons
                  .map((reason) => _buildReasonItem(reason))
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildReasonItem(String reason) {
    final bool isSelected = reason == _selectedReason;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReason = reason;
          _isDropdownOpen = false;
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.whiteClr,
          border: Border(
            left: isSelected
                ? BorderSide(color: AppColors.primaryClr, width: 3.w)
                : BorderSide.none,
          ),
        ),
        child: Text(reason, style: AppTextStyles.font14BlackMedium),
      ),
    );
  }
}