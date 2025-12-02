import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/network/logic/network_cubit.dart';
import 'package:mediconsult/features/network/logic/network_state.dart';

class NetworkFilterBottomSheet extends StatefulWidget {
  const NetworkFilterBottomSheet({super.key});

  @override
  State<NetworkFilterBottomSheet> createState() =>
      _NetworkFilterBottomSheetState();
}

class _NetworkFilterBottomSheetState extends State<NetworkFilterBottomSheet> {
  int? _selectedCategoryId;
  int? _selectedGovernmentId;
  int? _selectedCityId;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<NetworkCubit>();
    _selectedCategoryId = cubit.selectedCategoryId;
    _selectedGovernmentId = cubit.selectedGovernmentId;
    _selectedCityId = cubit.selectedCityId;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cubit = context.read<NetworkCubit>();

    if (cubit.governments.isEmpty) {
      cubit.getGovernments(context: context);
    }

    if (_selectedGovernmentId != null) {
      cubit.getCitiesByGovernment(_selectedGovernmentId!, context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteClr,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.greyClr.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 16.h),

          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'bottom_sheet.filter'.tr(),
                  style: AppTextStyles.font18BlackSemiBold(context),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategoryId = null;
                      _selectedGovernmentId = null;
                      _selectedCityId = null;
                    });
                  },
                  child: Text(
                    'bottom_sheet.clear'.tr(),
                    style: AppTextStyles.font14PrimaryMedium(context),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Dropdown
                  Text(
                    'bottom_sheet.choose_category'.tr(),
                    style: AppTextStyles.font14BlackMedium(context),
                  ),
                  SizedBox(height: 12.h),
                  BlocBuilder<NetworkCubit, NetworkState>(
                    buildWhen: (previous, current) =>
                        current is CategoriesLoading ||
                        current is CategoriesSuccess ||
                        current is CategoriesError,
                    builder: (context, state) {
                      final categories = context
                          .read<NetworkCubit>()
                          .categories;

                      if (categories.isEmpty) {
                        return Text(
                          'bottom_sheet.no_categories'.tr(),
                          style: AppTextStyles.font12GreyRegular(context),
                        );
                      }

                      return DropdownButtonFormField<int>(
                        initialValue: _selectedCategoryId,
                        decoration: InputDecoration(
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
                        hint: Text(
                          'bottom_sheet.choose_category'.tr(),
                          style: AppTextStyles.font14GreyRegular(context),
                        ),
                        items: categories.map((category) {
                          return DropdownMenuItem<int>(
                            value: category.id,
                            child: Text(
                              category.name,
                              style: AppTextStyles.font14BlackRegular(context),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryId = value;
                          });
                        },
                      );
                    },
                  ),

                  SizedBox(height: 20.h),

                  // Government Dropdown
                  Text(
                    'bottom_sheet.choose_government'.tr(),
                    style: AppTextStyles.font14BlackMedium(context),
                  ),
                  SizedBox(height: 12.h),
                  BlocBuilder<NetworkCubit, NetworkState>(
                    buildWhen: (previous, current) =>
                        current is GovernmentsLoading ||
                        current is GovernmentsSuccess ||
                        current is GovernmentsError,
                    builder: (context, state) {
                      final governments = context
                          .read<NetworkCubit>()
                          .governments;

                      if (governments.isEmpty) {
                        return Text(
                          'bottom_sheet.no_governments'.tr(),
                          style: AppTextStyles.font12GreyRegular(context),
                        );
                      }

                      return DropdownButtonFormField<int>(
                        initialValue: _selectedGovernmentId,
                        decoration: InputDecoration(
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
                        hint: Text(
                          'bottom_sheet.choose_government'.tr(),
                          style: AppTextStyles.font14GreyRegular(context),
                        ),
                        items: governments.map((government) {
                          return DropdownMenuItem<int>(
                            value: government.id,
                            child: Text(
                              government.name,
                              style: AppTextStyles.font14BlackRegular(context),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedGovernmentId = value;
                            _selectedCityId = null;
                            if (value != null) {
                              context
                                  .read<NetworkCubit>()
                                  .getCitiesByGovernment(
                                    value,
                                    context: context,
                                  );
                            }
                          });
                        },
                      );
                    },
                  ),

                  // City Dropdown (only show if government is selected)
                  if (_selectedGovernmentId != null) ...[
                    SizedBox(height: 20.h),
                    Text(
                      'bottom_sheet.choose_city'.tr(),
                      style: AppTextStyles.font14BlackMedium(context),
                    ),
                    SizedBox(height: 12.h),
                    BlocBuilder<NetworkCubit, NetworkState>(
                      buildWhen: (previous, current) =>
                          current is CitiesLoading ||
                          current is CitiesSuccess ||
                          current is CitiesError,
                      builder: (context, state) {
                        if (state is CitiesLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final cities = context.read<NetworkCubit>().cities;

                        if (cities.isEmpty) {
                          return Text(
                            'bottom_sheet.no_cities'.tr(),
                            style: AppTextStyles.font12GreyRegular(context),
                          );
                        }

                        return DropdownButtonFormField<int>(
                          initialValue: _selectedCityId,
                          decoration: InputDecoration(
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
                          hint: Text(
                            'bottom_sheet.choose_city'.tr(),
                            style: AppTextStyles.font14GreyRegular(context),
                          ),
                          items: cities.map((city) {
                            return DropdownMenuItem<int>(
                              value: city.cityId,
                              child: Text(
                                city.cityName,
                                style: AppTextStyles.font14BlackRegular(
                                  context,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCityId = value;
                            });
                          },
                        );
                      },
                    ),
                  ],

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),

          // Apply Button
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
            child: SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () {
                  // تطبيق الفلترة باستخدام المعايير المحددة
                  // Preserve current search when applying filters
                  final cubit = context.read<NetworkCubit>();
                  cubit.searchProviders(
                    searchKey: cubit.searchKey, // Preserve current search
                    categoryId: _selectedCategoryId,
                    governmentId: _selectedGovernmentId,
                    cityId: _selectedCityId,
                    resetPage: true,
                    context: context,
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryClr,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'common.choose'.tr(),
                  style: AppTextStyles.font16WhiteMedium(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
