import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/refund/presentation/cubit/refund_reasons_cubit.dart';
import 'package:mediconsult/features/refund/data/refund_types_reasons_models.dart';

class ReasonSelector extends StatefulWidget {
  const ReasonSelector({
    super.key,
    this.onReasonSelected,
    this.selectedReasonId,
  });

  final Function(int id, String name)? onReasonSelected;
  final int? selectedReasonId;

  @override
  State<ReasonSelector> createState() => _ReasonSelectorState();
}

class _ReasonSelectorState extends State<ReasonSelector> {
  bool _isDropdownOpen = false;
  int? _selectedReasonId;
  String? _selectedReasonName;

  @override
  void initState() {
    super.initState();
    _selectedReasonId = widget.selectedReasonId;
    // Load refund reasons when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RefundReasonsCubit>().loadRefundReasons(context.locale.languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefundReasonsCubit, RefundReasonsState>(
      builder: (context, state) {
        if (state is RefundReasonsLoading) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.greyClr.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is RefundReasonsFailed) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'Failed to load reasons',
              style: AppTextStyles.font14GreyRegular(context),
            ),
          );
        }

        final reasons = state is RefundReasonsLoaded ? state.reasons : <RefundReason>[];

        return Column(
          children: [
            GestureDetector(
              onTap: reasons.isEmpty
                  ? null
                  : () {
                      FocusScope.of(context).unfocus();
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
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
                        _selectedReasonName ?? 'placeholders.select_refund_reason'.tr(),
                        style: _selectedReasonName != null
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
            if (_isDropdownOpen && reasons.isNotEmpty)
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
                constraints: BoxConstraints(maxHeight: 200.h),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: reasons.length,
                  itemBuilder: (context, index) => _buildReasonItem(reasons[index]),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildReasonItem(RefundReason reason) {
    final bool isSelected = reason.id == _selectedReasonId;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReasonId = reason.id;
          _selectedReasonName = reason.name;
          _isDropdownOpen = false;
        });
        widget.onReasonSelected?.call(reason.id, reason.name);
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
        child: Text(reason.name, style: AppTextStyles.font14BlackMedium(context)),
      ),
    );
  }
}
