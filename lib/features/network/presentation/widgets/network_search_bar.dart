import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      // Unfocus immediately
      _focusNode.unfocus();
      
      // Also unfocus through system channels
      FocusScope.of(context).unfocus();
      FocusManager.instance.primaryFocus?.unfocus();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      
      // Also call the callback if provided
      widget.onUnfocusRequested?.call();
      
      // Ensure unfocus after a frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.isShowCaseActive) {
          _focusNode.unfocus();
          FocusScope.of(context).unfocus();
        }
      });
    }
    
    // When showcase becomes inactive, ensure TextField is enabled
    if (!widget.isShowCaseActive && oldWidget.isShowCaseActive) {
      // Force rebuild to ensure TextField is enabled
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Unfocus search field when showcase becomes active
    if (widget.isShowCaseActive && _focusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.isShowCaseActive) {
          _focusNode.unfocus();
          FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        }
      });
    }

    return AbsorbPointer(
      absorbing: widget.isShowCaseActive,
      child: Row(
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
                  enabled: true,
                  readOnly: false,
                  decoration: InputDecoration(
                    hintText: 'network.search_placeholder'.tr(),
                    hintStyle: AppTextStyles.font14GreyRegular(context),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.greyClr,
                      size: 20.sp,
                    ),
                    suffixIcon: widget.searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: AppColors.greyClr,
                              size: 20.sp,
                            ),
                            onPressed: () {
                              widget.searchController.clear();
                              _focusNode.requestFocus();
                            },
                          )
                        : null,
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
                  onChanged: (value) {
                    // Force rebuild to show/hide clear button
                    setState(() {});
                  },
                ),
        ),
        SizedBox(width: 12.w),
        GestureDetector(
          onTap: () {
            // Always allow filter tap unless showcase is active
            if (widget.isShowCaseActive) return;
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
        ],
      ),
    );
  }
}
