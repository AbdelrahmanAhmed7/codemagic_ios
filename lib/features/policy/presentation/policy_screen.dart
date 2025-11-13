import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/features/policy/presentation/policy_details_screen.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/di/service_locator.dart';
import 'package:mediconsult/features/policy/presentation/cubit/get_policy_categories_cubit.dart';
import 'package:mediconsult/features/policy/presentation/cubit/get_policy_categories_state.dart';
import 'package:mediconsult/core/utils/language_helper.dart';
import 'package:mediconsult/features/policy/data/policy_categories_response.dart';
import 'package:mediconsult/shared/widgets/error_state_widget.dart';

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
              context.read<GetPolicyCategoriesCubit>().getPolicyCategories(
                LanguageHelper.getLanguageCode(context),
              );
            });
            _hasLoadedInitialData = true;
          }

          return Scaffold(
            backgroundColor: AppColors.lightGreyClr,
            body: SafeArea(
              child: Column(
                children: [
                  PageHeader(
                    title: _showDetails
                        ? 'policy.details'.tr()
                        : 'policy.title'.tr(),
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
                                color: AppColors.greyClr.withValues(
                                  alpha: 0.08,
                                ),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _showDetails
                                ? _buildServiceDetails()
                                : BlocBuilder<
                                    GetPolicyCategoriesCubit,
                                    GetPolicyCategoriesState
                                  >(
                                    builder: (context, state) {
                                      return state.when(
                                        initial: () => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        loading: () => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        failed: (message) => ErrorStateWidget(
                                          message: message,
                                          icon: Icons.policy_outlined,
                                          onRetry: () {
                                            context
                                                .read<GetPolicyCategoriesCubit>()
                                                .getPolicyCategories(
                                                  LanguageHelper.getLanguageCode(
                                                    context,
                                                  ),
                                                );
                                          },
                                          retryButtonText: 'common.try_again'.tr(),
                                        ),
                                        loaded: (response) {
                                          return _buildServicesList(
                                            response.data.categories,
                                          );
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
        SizedBox(height: 12.h),

        Expanded(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final category = categories[index];
              final iconPath = _getCategoryIcon(category.serviceClassName);

              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 1, end: 1),
                duration: const Duration(milliseconds: 200),
                builder: (context, scale, child) =>
                    Transform.scale(scale: scale, child: child),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  elevation: 0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16.r),
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
                    splashColor: AppColors.primaryClr.withValues(alpha: 0.1),
                    highlightColor: Colors.transparent,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.primaryClr.withValues(alpha: 0.1),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52.w,
                            height: 52.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primaryClr.withValues(alpha: 0.15),
                                  AppColors.primaryClr.withValues(alpha: 0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.w),
                              child: iconPath != null
                                  ? Image.asset(iconPath, fit: BoxFit.contain)
                                  : Icon(
                                      Icons.local_hospital,
                                      color: AppColors.primaryClr,
                                      size: 28.sp,
                                    ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              category.serviceClassName,
                              style: AppTextStyles.font14BlackMedium(context)
                                  .copyWith(
                                    color: AppColors.blackClr,
                                    height: 1.4,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16.sp,
                            color: Colors.grey[500],
                          ),
                        ],
                      ),
                    ),
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

  String? _getCategoryIcon(String categoryName) {
    if (categoryName.contains('Acute Medication') ||
        categoryName.contains('ادويه عاديه')) {
      return AppAssets.pharmacyCat;
    } else if (categoryName.contains('Chronic Medication') ||
        categoryName.contains('ادويه مزمنه')) {
      return AppAssets.pharmacyCat;
    } else if (categoryName.contains('Dental') ||
        categoryName.contains('مراكز طب الاسنان') ||
        categoryName.contains('أسنان')) {
      return AppAssets.dentalCat;
    } else if (categoryName.contains('Lab') ||
        categoryName.contains('معمل') ||
        categoryName.contains('تحاليل')) {
      return AppAssets.labTest;
    } else if (categoryName.contains('Glasses') ||
        categoryName.contains('نظارة طبية') ||
        categoryName.contains('بصريات')) {
      return AppAssets.glasses;
    } else if (categoryName.contains('pre-exsiting cases') ||
        categoryName.contains('الحالات السابقة')) {
      return AppAssets.pre;
    } else if (categoryName.contains('Ambulance') ||
        categoryName.contains('سيارة الأسعاف') ||
        categoryName.contains('دكتور')) {
      return AppAssets.ambulanceCat;
    } else if (categoryName.contains('Scan Investigations') ||
        categoryName.contains('أشعة') ||
        categoryName.contains('اشعة')) {
      return AppAssets.scanCat;
    } else if (categoryName.contains(
          'Hospitals and Medical Centers Examination',
        ) ||
        categoryName.contains('الكشف بالمستشفيات و المراكز الطبية')) {
      return AppAssets.hospitalScan;
    } else if (categoryName.contains('Inpatient') ||
        categoryName.contains('عمليات')) {
      return AppAssets.inpatientCat;
    } else if (categoryName.contains('Critical') ||
        categoryName.contains('الحالات الحرجة')) {
      return AppAssets.critical;
    } else if (categoryName.contains('Emergency (up to 24 hours) ') ||
        categoryName.contains('الطوارئ')) {
      return AppAssets.emergencyCat;
    }
    return null;
  }
}