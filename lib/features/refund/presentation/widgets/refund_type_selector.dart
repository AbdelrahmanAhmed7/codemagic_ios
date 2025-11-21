import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/constants/app_assets.dart';

class RefundTypeSelector extends StatefulWidget {
  const RefundTypeSelector({super.key, this.onChanged});

  final ValueChanged<String>? onChanged;

  @override
  State<RefundTypeSelector> createState() => _RefundTypeSelectorState();
}

class _RefundTypeSelectorState extends State<RefundTypeSelector> {
  bool _isDropdownOpen = false;
  String? _selectedType;

  final List<RefundTypeItem> _refundTypes = [
    RefundTypeItem(
      assetImage: AppAssets.emergency,
      name: 'Emergency',
      color: AppColors.primaryClr,
    ),
    RefundTypeItem(
      assetImage: AppAssets.glasses,
      name: 'Glasses',
      color: AppColors.primaryClr,
    ),
    RefundTypeItem(
      assetImage: AppAssets.laboratory,
      name: 'Laboratory',
      color: AppColors.primaryClr,
    ),
    RefundTypeItem(
      assetImage: AppAssets.scan,
      name: 'Scan',
      color: AppColors.primaryClr,
    ),
    RefundTypeItem(
      assetImage: AppAssets.medi,
      name: 'Medicines',
      color: AppColors.primaryClr,
    ),
    RefundTypeItem(
      assetImage: AppAssets.dental,
      name: 'Dental',
      color: AppColors.primaryClr,
    ),
    RefundTypeItem(
      assetImage: AppAssets.physiotherapy,
      name: 'Physiotherapy',
      color: AppColors.primaryClr,
    ),
    RefundTypeItem(
      assetImage: AppAssets.examinations,
      name: 'Examinations',
      color: AppColors.primaryClr,
    ),
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
                if (_selectedType != null) ...[
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: AppColors.lightGreyClr,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Image.asset(
                      _refundTypes
                          .firstWhere((type) => type.name == _selectedType)
                          .assetImage,
                      width: 16.w,
                      height: 16.w,
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
                Expanded(
                  child: Text(
                    _selectedType ?? 'Select refund type',
                    style: _selectedType != null
                        ? AppTextStyles.font14BlackMedium(context)
                        : AppTextStyles.font14GreyRegular(context),
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
            constraints: BoxConstraints(maxHeight: 240.h),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _refundTypes.length,
              itemBuilder: (context, index) =>
                  _buildTypeItem(_refundTypes[index]),
            ),
          ),
      ],
    );
  }

  Widget _buildTypeItem(RefundTypeItem type) {
    final bool isSelected = type.name == _selectedType;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedType = type.name;
          _isDropdownOpen = false;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(type.name);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.whiteClr,
          border: Border(
            left: isSelected
                ? BorderSide(color: AppColors.primaryClr, width: 3.w)
                : BorderSide.none,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: AppColors.lightGreyClr,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Image.asset(type.assetImage, width: 16.w, height: 16.w),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                type.name,
                style: AppTextStyles.font14BlackMedium(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RefundTypeItem {
  final String assetImage;
  final String name;
  final Color color;

  RefundTypeItem({
    required this.assetImage,
    required this.name,
    required this.color,
  });
}
