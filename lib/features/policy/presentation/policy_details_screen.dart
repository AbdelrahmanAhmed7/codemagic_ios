import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/policy/data/policy_mock_data.dart';
import 'package:mediconsult/features/policy/presentation/widgets/pharmacy_card.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';

class PolicyDetailsScreen extends StatefulWidget {
  final String serviceName;
  
  const PolicyDetailsScreen({super.key, required this.serviceName});

  @override
  State<PolicyDetailsScreen> createState() => _PolicyDetailsScreenState();
}

class _PolicyDetailsScreenState extends State<PolicyDetailsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final policyDetails = PolicyMockData.getPolicyDetailsByService(widget.serviceName);

    return Scaffold(
      backgroundColor: AppColors.lightGreyClr,
      body: SafeArea(
        child: Column(
          children: [
            PageHeader(title: '${widget.serviceName} Policy', backPath: '/policy'),
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
                    child: SingleChildScrollView(
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
                                  hintText: 'Search',
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
                              'Policy Details',
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
                                          'Coverage',
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
                                              policyDetails.serviceName,
                                              style: AppTextStyles.font10GreyRegular(context),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        policyDetails.coveragePercentage,
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryClr,
                                        ),
                                      ),
                                      Text(
                                        policyDetails.coverageType,
                                        style: AppTextStyles.font10GreyRegular(context),
                                      ),
                                    ],
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
                                  'Providers',
                                  style: AppTextStyles.font16BlueMedium(context),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // TODO: Show all providers
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'See all',
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
                              itemCount: policyDetails.providers.length,
                              itemBuilder: (context, index) {
                                return PharmacyCard(
                                  provider: policyDetails.providers[index],
                                );
                              },
                            ),
                          ],
                        ),
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
}
