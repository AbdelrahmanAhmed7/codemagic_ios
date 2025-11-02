import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/policy/data/policy_mock_data.dart';
import 'package:mediconsult/features/policy/data/policy_models.dart';
import 'package:mediconsult/features/policy/presentation/policy_details_screen.dart';
import 'package:mediconsult/features/policy/presentation/widgets/policy_item_card.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';

class PolicyScreen extends StatefulWidget {
  const PolicyScreen({super.key});

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showDetails = false;
  String _selectedServiceId = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final services = PolicyMockData.getServices()
        .map((s) => PolicyItem.fromService(s))
        .toList();

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
                          : _buildServicesList(services),
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

  Widget _buildServicesList(List<PolicyItem> services) {
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
            itemCount: services.length,
            itemBuilder: (context, index) {
              return PolicyItemCard(
                item: services[index],
                onTap: () {
                  setState(() {
                    _showDetails = true;
                    _selectedServiceId = services[index].id;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServiceDetails() {
    // استخدام الخدمة المحددة للانتقال إلى شاشة التفاصيل
    final services = PolicyMockData.getServices()
        .map((s) => PolicyItem.fromService(s))
        .toList();
    final selectedService = services.firstWhere(
      (service) => service.id == _selectedServiceId,
      orElse: () => services.first,
    );
    
    // استخدام Navigator للانتقال إلى شاشة التفاصيل
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PolicyDetailsScreen(
            serviceName: selectedService.name,
          ),
        ),
      ).then((_) {
        setState(() {
          _showDetails = false;
        });
      });
    });
    
    // إرجاع مساحة فارغة لأن الشاشة ستتغير
    return const SizedBox.shrink();
  }
}
