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

  const NetworkSearchBar({
    super.key,
    required this.searchController,
    required this.onFilterTap,
    required this.onSearchSubmitted,
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
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
        GestureDetector(
          onTap: () {
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
    );
  }
}
