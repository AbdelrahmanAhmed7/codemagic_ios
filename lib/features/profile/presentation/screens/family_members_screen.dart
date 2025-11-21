import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';

class FamilyMembersScreen extends StatefulWidget {
  const FamilyMembersScreen({super.key});

  @override
  State<FamilyMembersScreen> createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends State<FamilyMembersScreen> {
  // Sample data for family members
  final List<Map<String, dynamic>> _familyMembers = [
    {
      'name': 'Ahmed Mohamed Adel Amin',
      'role': 'Main Member',
      'status': 'Activated Member',
      'image': 'assets/approval/ahmed.png',
    },
    {
      'name': 'Noha Khaled Ali Mohamed',
      'role': 'Spouse',
      'status': 'Activated Member',
      'image': 'assets/approval/noha.png',
    },
    {
      'name': 'Youssef Ahmed Mohamed Adel',
      'role': 'Son',
      'status': 'Activated Member',
      'image': 'assets/approval/ali.png',
    },
    {
      'name': 'Laila Ahmed Mohamed Adel',
      'role': 'Daughter',
      'status': 'Deactivated Member',
      'image': 'assets/approval/laila.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyClr,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(title: 'Family Members', backPath: '/profile'),
            Expanded(
              child: Transform.translate(
                offset: Offset(0, -20.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Container(
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
                    child: ListView(
                      padding: EdgeInsets.all(16.w),
                      children: [
                        _buildFamilyMembersList(),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: _buildAddFamilyMemberButton(),
    );
  }

  Widget _buildFamilyMembersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Members', style: AppTextStyles.font14BlackMedium),
        SizedBox(height: 22.h),
        Column(
          children: List.generate(_familyMembers.length, (index) {
            final member = _familyMembers[index];
            final isMainMember = member['role'] == 'Main Member';
            return Column(
              children: [
                _buildMemberTile(member, isMainMember),
                if (index < _familyMembers.length - 1)
                  Divider(height: 16.h, thickness: 1),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildAddFamilyMemberButton() {
    return FloatingActionButton(
      shape: const CircleBorder(),
      backgroundColor: AppColors.primaryClr,
      onPressed: () {
        context.go('/add-member');
      },
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  Widget _buildMemberTile(Map<String, dynamic> member, bool isMainMember) {
  final bool isActivated = member['status'] == 'Activated Member';

  return Padding(
    padding: EdgeInsets.symmetric(vertical: 12.h),
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(45.r),
              child: Image.asset(
                member['image'],
                width: 75.w,
                height: 90.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member['name'], style: AppTextStyles.font12BlackMedium),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Image.asset(
                        AppAssets.user,
                        width: 16.w,
                        height: 12.h,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        member['role'],
                        style: AppTextStyles.font12GreyRegular,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: isActivated ? Colors.green : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        member['status'],
                        style: AppTextStyles.font12GreyRegular.copyWith(
                          color: isActivated ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.goldPlanColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          AppAssets.goldPlan,
                          width: 12.sp,
                          height: 12.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Gold Plan',
                          style: AppTextStyles.font10GreyRegular.copyWith(
                            color: Color(0xff484848),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isMainMember)
          Positioned(
            right: 4,
            bottom: 0,
            child: Image.asset(AppAssets.deleteIcon,width: 24.w,height: 24.h,),
          ),
      ],
    ),
  );
}

}
