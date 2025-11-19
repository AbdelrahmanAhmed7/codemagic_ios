import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/policy/data/policy_details_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/di/service_locator.dart';
import 'package:mediconsult/core/utils/language_helper.dart';
import 'package:mediconsult/features/policy/presentation/cubit/get_policy_details_cubit.dart';
import 'package:mediconsult/features/policy/presentation/cubit/get_policy_details_state.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:mediconsult/features/policy/presentation/policy_providers_screen.dart';
import 'package:mediconsult/features/policy/presentation/widgets/policy_coverage_card.dart';
import 'package:mediconsult/features/policy/presentation/widgets/policy_provider_card.dart';
import 'package:mediconsult/features/policy/presentation/widgets/policy_service_helper.dart';
import 'package:mediconsult/shared/widgets/error_state_widget.dart';

class PolicyDetailsScreen extends StatefulWidget {
  final String serviceName;
  final int categoryId;

  const PolicyDetailsScreen({
    super.key,
    required this.serviceName,
    required this.categoryId,
  });

  @override
  State<PolicyDetailsScreen> createState() => _PolicyDetailsScreenState();
}

class _PolicyDetailsScreenState extends State<PolicyDetailsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasLoaded = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyClr,
      body: SafeArea(
        child: BlocProvider<GetPolicyDetailsCubit>(
          create: (_) => sl<GetPolicyDetailsCubit>(),
          child: Builder(
            builder: (context) {
              if (!_hasLoaded) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.read<GetPolicyDetailsCubit>().getDetails(
                    LanguageHelper.getLanguageCode(context),
                    widget.categoryId,
                  );
                });
                _hasLoaded = true;
              }

              return Column(
                children: [
                  PageHeader(
                    title: '${PolicyServiceHelper.getLocalizedServiceName(widget.serviceName)} ${'policy_screen.policy'.tr()}',
                    backPath: '/policy',
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
                          child:
                              BlocBuilder<
                                GetPolicyDetailsCubit,
                                GetPolicyDetailsState
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
                                            .read<GetPolicyDetailsCubit>()
                                            .getDetails(
                                              LanguageHelper.getLanguageCode(context),
                                              widget.categoryId,
                                            );
                                      },
                                      retryButtonText: 'common.try_again'.tr(),
                                    ),
                                    loaded: (response) =>
                                        _buildDetailsContent(response.data),
                                  );
                                },
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsContent(PolicyDetailsData details) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 14.h),

            // Policy Details Section
            Text(
              'policy_screen.details'.tr(),
              style: AppTextStyles.font16BlueMedium(context),
            ),
            SizedBox(height: 16.h),

            PolicyCoverageCard(
              serviceName: widget.serviceName,
              slLimit: '${details.slCopayment}',
              serviceIcon: PolicyServiceHelper.getServiceIcon(widget.serviceName),
            ),
            SizedBox(height: 24.h),

            if (details.providers.isNotEmpty) ...[
              // Providers Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    PolicyServiceHelper.getProvidersPluralLabel(widget.serviceName).tr(),
                    style: AppTextStyles.font16BlueMedium(context),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PolicyProvidersScreen(
                            serviceName: widget.serviceName,
                            categoryId: widget.categoryId,
                          ),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'home.see_all'.tr(),
                      style: AppTextStyles.font12BlueRegular(context),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: (details.providers.length >= 3) ? 3 : details.providers.length,
                itemBuilder: (context, index) {
                  return PolicyProviderCard(provider: details.providers[index]);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

}
