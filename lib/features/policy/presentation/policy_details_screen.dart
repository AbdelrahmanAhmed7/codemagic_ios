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
                    title: '${_localizedServiceName(context)} ${'policy_screen.policy'.tr()}',
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
                                    failed: (message) => Center(
                                      child: Text(
                                        message,
                                        style: AppTextStyles.font14BlackMedium(
                                          context,
                                        ),
                                      ),
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
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'policy_screen.search'.tr(),
                  hintStyle: AppTextStyles.font14GreyRegular(context),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.greyClr,
                    size: 20.sp,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Policy Details Section
            Text(
              'policy_screen.details'.tr(),
              style: AppTextStyles.font16BlueMedium(context),
            ),
            SizedBox(height: 16.h),

            // Coverage Card
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F7FF),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'policy_screen.coverage'.tr(),
                          style: AppTextStyles.font14BlackMedium(context),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(
                              _getServiceIcon(),
                              color: AppColors.primaryClr,
                              size: 14.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              widget.serviceName,
                              style: AppTextStyles.font10GreyRegular(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${details.slLimit}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 24.sp,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryClr,
                                          ),
                                        ),
                                        Text(
                                          'Limit',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyles.font10GreyRegular(context),
                                        ),
                                      ],
                                    ),
                                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Providers Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                                Text(
                                  _providersPluralLabel(context).tr(),
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

            // Providers List
                            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
                              itemCount: (details.providers.length >= 3) ? 3 : details.providers.length,
              itemBuilder: (context, index) {
                final provider = details.providers[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.whiteClr,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFFECECEC)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A8A),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.r),
                            child: Image.network(
                              provider.logo,
                              width: 48.w,
                              height: 48.w,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.local_hospital,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.providerName,
                              style: AppTextStyles.font14BlackMedium(context),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Copayment: ${provider.copaymentPercent}%',
                              style: AppTextStyles.font12GreyRegular(context),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Future: call provider details by providerId and navigate
                        },
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getServiceIcon() {
    switch (widget.serviceName.toLowerCase()) {
      case 'pharmacy':
        return Icons.local_pharmacy;
      case 'lab':
        return Icons.biotech;
      case 'hospital':
        return Icons.local_hospital;
      case 'doctor':
        return Icons.medical_services;
      case 'scan lab':
        return Icons.scanner;
      default:
        return Icons.business;
    }
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
