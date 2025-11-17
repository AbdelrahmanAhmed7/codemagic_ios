import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/features/refund/presentation/cubit/refund_types_cubit.dart';
import 'package:mediconsult/features/refund/data/refund_types_reasons_models.dart';

class RefundTypeSelector extends StatefulWidget {
  const RefundTypeSelector({
    super.key,
    this.onTypeSelected,
    this.selectedTypeId,
  });

  final Function(RefundType type)? onTypeSelected;
  final int? selectedTypeId;

  @override
  State<RefundTypeSelector> createState() => _RefundTypeSelectorState();
}

class _RefundTypeSelectorState extends State<RefundTypeSelector> {
  bool _isDropdownOpen = false;
  int? _selectedTypeId;
  String? _selectedTypeName;

  // Map type names to icons
  final Map<String, String> _typeIcons = {
    'Emergency': AppAssets.emergency,
    'Glasses': AppAssets.glasses,
    'Lab': AppAssets.laboratory,
    'Laboratory': AppAssets.laboratory,
    'Scan': AppAssets.scan,
    'Examination': AppAssets.examinations,
    'Examinations': AppAssets.examinations,
    'Medicines': AppAssets.medi,
    'Dental': AppAssets.dental,
    'Physiotherapy': AppAssets.physiotherapy,
  };

  @override
  void initState() {
    super.initState();
    _selectedTypeId = widget.selectedTypeId;
    // Load refund types when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RefundTypesCubit>().loadRefundTypes(context.locale.languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefundTypesCubit, RefundTypesState>(
      builder: (context, state) {
        if (state is RefundTypesLoading) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.greyClr.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is RefundTypesFailed) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'Failed to load types',
              style: AppTextStyles.font14GreyRegular(context),
            ),
          );
        }

        // Get types from loaded state
        final types = state is RefundTypesLoaded ? state.types : <RefundType>[];

        return Column(
          children: [
            GestureDetector(
              onTap: types.isEmpty ? null : () {
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
                    if (_selectedTypeName != null) ...[
                      Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          color: AppColors.lightGreyClr,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Image.asset(
                          _getIconForType(_selectedTypeName!),
                          width: 16.w,
                          height: 16.w,
                        ),
                      ),
                      SizedBox(width: 8.w),
                    ],
                    Expanded(
                      child: Text(
                        _selectedTypeName ?? 'placeholders.select_refund_type'.tr(),
                        style: _selectedTypeName != null
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
            if (_isDropdownOpen && types.isNotEmpty)
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
                  itemCount: types.length,
                  itemBuilder: (context, index) => _buildTypeItem(types[index]),
                ),
              ),
          ],
        );
      },
    );
  }

  String _getIconForType(String typeName) {
    return _typeIcons[typeName] ?? AppAssets.emergency;
  }

  Widget _buildTypeItem(RefundType type) {
    final bool isSelected = type.id == _selectedTypeId;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTypeId = type.id;
          _selectedTypeName = type.name;
          _isDropdownOpen = false;
        });
        widget.onTypeSelected?.call(type);
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
              child: Image.asset(
                _getIconForType(type.name),
                width: 16.w,
                height: 16.w,
              ),
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
