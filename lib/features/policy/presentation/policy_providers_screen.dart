import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mediconsult/core/di/service_locator.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/utils/language_helper.dart';
import 'package:mediconsult/features/policy/presentation/cubit/get_policy_details_cubit.dart';
import 'package:mediconsult/features/policy/presentation/cubit/get_policy_details_state.dart';
import 'package:mediconsult/features/policy/data/policy_details_response.dart';
import 'package:mediconsult/features/policy/presentation/widgets/policy_provider_card.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:mediconsult/shared/widgets/error_state_widget.dart';

class PolicyProvidersScreen extends StatefulWidget {
  final String serviceName;
  final int categoryId;

  const PolicyProvidersScreen({super.key, required this.serviceName, required this.categoryId});

  @override
  State<PolicyProvidersScreen> createState() => _PolicyProvidersScreenState();
}

class _PolicyProvidersScreenState extends State<PolicyProvidersScreen> {
  bool _hasLoaded = false;

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
                    title: '${_localizedServiceName(context)} ${'policy_screen.providers'.tr()}',
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
                                color: AppColors.greyClr.withValues(alpha: 0.08),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: BlocBuilder<GetPolicyDetailsCubit, GetPolicyDetailsState>(
                            builder: (context, state) {
                              return state.when(
                                initial: () => const Center(child: CircularProgressIndicator()),
                                loading: () => const Center(child: CircularProgressIndicator()),
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
                                loaded: (response) => _ProvidersList(
                                  details: response.data,
                                  providersLabelKey: _providersPluralLabel(context),
                                ),
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

  String _providersPluralLabel(BuildContext context) {
    final name = widget.serviceName.toLowerCase();
    if (name.contains('pharmacy')) return 'policy_screen.pharmacies';
    if (name.contains('lab')) return 'policy_screen.labs';
    if (name.contains('hospital')) return 'policy_screen.hospitals';
    if (name.contains('doctor')) return 'policy_screen.doctors';
    if (name.contains('scan')) return 'policy_screen.scan_labs';
    if (name.contains('specialized')) return 'policy_screen.specialized_centers';
    if (name.contains('physio')) return 'policy_screen.physiotherapy';
    if (name.contains('optical')) return 'policy_screen.optical_centers';
    return 'policy_screen.providers';
  }

  String _localizedServiceName(BuildContext context) {
    final name = widget.serviceName.toLowerCase();
    if (name.contains('pharmacy')) return 'policy_screen.pharmacy'.tr();
    if (name.contains('lab')) return 'policy_screen.lab'.tr();
    if (name.contains('hospital')) return 'policy_screen.hospital'.tr();
    if (name.contains('doctor')) return 'policy_screen.doctor'.tr();
    if (name.contains('scan')) return 'policy_screen.scan_lab'.tr();
    if (name.contains('specialized')) return 'policy_screen.specialized_center'.tr();
    if (name.contains('physio')) return 'policy_screen.physiotherapy'.tr();
    if (name.contains('optical')) return 'policy_screen.optical_center'.tr();
    return widget.serviceName;
  }
}

class _ProvidersList extends StatelessWidget {
  final PolicyDetailsData details;
  final String providersLabelKey;
  const _ProvidersList({required this.details, required this.providersLabelKey});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  providersLabelKey.tr(),
                  style: AppTextStyles.font16BlueMedium(context),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: details.providers.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final provider = details.providers[index];
                return PolicyProviderCard(
                  provider: provider,
                  onTap: () {},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}