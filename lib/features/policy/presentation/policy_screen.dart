import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/policy/presentation/policy_details_screen.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/di/service_locator.dart';
import 'package:mediconsult/features/policy/presentation/cubit/get_policy_categories_cubit.dart';
import 'package:mediconsult/features/policy/presentation/cubit/get_policy_categories_state.dart';
import 'package:mediconsult/core/utils/language_helper.dart';
import 'package:mediconsult/features/policy/data/policy_categories_response.dart';

class PolicyScreen extends StatefulWidget {
  const PolicyScreen({super.key});

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showDetails = false;
  bool _hasLoadedInitialData = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetPolicyCategoriesCubit>(
      create: (_) => sl<GetPolicyCategoriesCubit>(),
      child: Builder(
        builder: (context) {
          if (!_hasLoadedInitialData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<GetPolicyCategoriesCubit>()
                .getPolicyCategories(LanguageHelper.getLanguageCode(context));
            });
            _hasLoadedInitialData = true;
          }

          return Scaffold(
            backgroundColor: AppColors.lightGreyClr,
            body: SafeArea(
              child: Column(
                children: [
                  PageHeader(
                    title: _showDetails ? 'policy.details'.tr() : 'policy.title'.tr(),
                    onBack: _showDetails 
                      ? () => setState(() => _showDetails = false) 
                      : null,
                    backPath: _showDetails ? null : '/home',
                  ),
                  Expanded(
                    child: Transform.translate(
                      offset: Offset(0, -28.h),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.whiteClr,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.greyClr.withValues(alpha: 0.08),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _showDetails
                                ? _buildServiceDetails()
                                : BlocBuilder<GetPolicyCategoriesCubit, GetPolicyCategoriesState>(
                                    builder: (context, state) {
                                      return state.when(
                                        initial: () => const Center(child: CircularProgressIndicator()),
                                        loading: () => const Center(child: CircularProgressIndicator()),
                                        failed: (message) => Center(
                                          child: Text(
                                            message,
                                            style: AppTextStyles.font14BlackMedium(context),
                                          ),
                                        ),
                                        loaded: (response) {
                                          return _buildServicesList(response.data.categories);
                                        },
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServicesList(List<PolicyCategory> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Text(
          'policy.services'.tr(),
          style: AppTextStyles.font16BlackMedium(context),
        ),
        SizedBox(height: 8.h),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.8,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PolicyDetailsScreen(
                        serviceName: category.serviceClassName,
                        categoryId: category.id,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: _parseColor(category.color),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.whiteClr,
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: SizedBox(
                            width: 44.w,
                            height: 44.w,
                            child: Image.network(
                              category.image,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.image_not_supported,
                                size: 20.sp,
                                color: AppColors.greyClr,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        category.serviceClassName,
                        style: AppTextStyles.font12BlackMedium(context).copyWith(
                          color: AppColors.blackClr,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServiceDetails() {
    return const SizedBox.shrink();
  }

  Color _parseColor(String hexColor) {
    String value = hexColor.trim();
    if (value.isEmpty) return AppColors.primaryClr;
    if (value.startsWith('#')) value = value.substring(1);
    if (value.length == 6) {
      value = 'FF$value';
    }
    try {
      return Color(int.parse('0x$value'));
    } catch (_) {
      return AppColors.primaryClr;
    }
  }
}
