import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/network/logic/network_cubit.dart';

/// Network search bar widget with filter button
class NetworkSearchBar extends StatefulWidget {
  final TextEditingController searchController;
  final VoidCallback onFilterTap;
  final Function(String) onSearchSubmitted;
  final bool isShowCaseActive;
  final VoidCallback? onUnfocusRequested;

  const NetworkSearchBar({
    super.key,
    required this.searchController,
    required this.onFilterTap,
    required this.onSearchSubmitted,
    this.isShowCaseActive = false,
    this.onUnfocusRequested,
  });

  @override
  State<NetworkSearchBar> createState() => _NetworkSearchBarState();
}

class _NetworkSearchBarState extends State<NetworkSearchBar> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
  
  void forceUnfocus() {
    _focusNode.unfocus();
  }

  @override
  void didUpdateWidget(NetworkSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When showcase becomes active, immediately unfocus
    if (widget.isShowCaseActive && !oldWidget.isShowCaseActive) {
      _focusNode.unfocus();
      // Also call the callback if provided
      widget.onUnfocusRequested?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Unfocus search field when showcase becomes active
    if (widget.isShowCaseActive && _focusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _focusNode.unfocus();
        }
      });
    }

    return Row(
      children: [
        Expanded(
          child: widget.isShowCaseActive
              ? // Replace TextField with a non-interactive widget during showcase
              IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.lightGreyClr,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: AppColors.greyClr,
                          size: 20.sp,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          widget.searchController.text.isEmpty
                              ? 'network.search_placeholder'.tr()
                              : widget.searchController.text,
                          style: AppTextStyles.font14GreyRegular(context),
                        ),
                      ],
                    ),
                  ),
                )
              : // Normal TextField when showcase is not active
              TextField(
                  controller: widget.searchController,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'network.search_placeholder'.tr(),
                    hintStyle: AppTextStyles.font14GreyRegular(context),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.greyClr,
                      size: 20.sp,
                    ),
                    filled: true,
                    fillColor: AppColors.lightGreyClr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                  onSubmitted: widget.onSearchSubmitted,
                  onTapOutside: (event) {
                    // إخفاء الكيبورد عند الضغط خارج الحقل (iOS fix)
                    _focusNode.unfocus();
                  },
                ),
        ),
        SizedBox(width: 12.w),
        AbsorbPointer(
          absorbing: widget.isShowCaseActive,
          child: GestureDetector(
            onTap: widget.isShowCaseActive
                ? null
                : () {
                    // إخفاء الكيبورد عند الضغط على زر الفلتر
                    _focusNode.unfocus();
                    widget.onFilterTap();
                  },
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: context.watch<NetworkCubit>().hasActiveFilters
                    ? AppColors.primaryClr
                    : AppColors.lightGreyClr,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.tune,
                color: context.watch<NetworkCubit>().hasActiveFilters
                    ? AppColors.whiteClr
                    : AppColors.greyClr,
                size: 20.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
