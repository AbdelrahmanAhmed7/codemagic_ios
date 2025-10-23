import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/features/family_members/presentation/cubit/family_members_cubit.dart';
import 'package:mediconsult/features/family_members/presentation/cubit/family_members_state.dart';

class FamilyMembersScreen extends StatefulWidget {
  const FamilyMembersScreen({super.key});

  @override
  State<FamilyMembersScreen> createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends State<FamilyMembersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<FamilyMembersCubit>(context).getFamilyMembers('en');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyClr,
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(title: 'Family Member', backPath: '/home'),
            Expanded(
              child: Transform.translate(
                offset: Offset(0, -20.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Text(
                            'Members',
                            style: AppTextStyles.font14BlackMedium,
                          ),
                        ),
                        Expanded(
                          child: BlocBuilder<FamilyMembersCubit, FamilyMembersState>(
                            builder: (context, state) {
                              return state.when(
                                initial: () => const Center(child: CircularProgressIndicator()),
                                loading: () => const Center(child: CircularProgressIndicator()),
                                failed: (msg) => Center(child: Text(msg)),
                                loaded: (model) {
                                  final members = model.data.familyMembers;
                                  if (members.isEmpty) {
                                    return const Center(child: Text('No family members found'));
                                  }
                                  return RefreshIndicator(
                                    onRefresh: () => context.read<FamilyMembersCubit>().refreshFamilyMembers('en'),
                                    child: ListView.separated(
                                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                                      itemCount: members.length,
                                      separatorBuilder: (_, __) => SizedBox(height: 16.h),
                                      itemBuilder: (context, index) {
                                        final member = members[index];
                                        return _buildMemberCard(member);
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   shape: const CircleBorder(),
      //   backgroundColor: AppColors.primaryClr,
      //   onPressed: () {
      //     context.go('/add-member');
      //   },
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
    );
  }

  Widget _buildMemberCard(member) {
    // Default to 'Gold Plan' if memberStatus is empty or null
    final String displayStatus = (member.memberStatus != null && member.memberStatus.isNotEmpty)
        ? member.memberStatus
        : 'Activated Member';
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 32.r,
          backgroundImage: (member.memberImage != null && member.memberImage!.isNotEmpty)
              ? NetworkImage(member.memberImage!)
              : const AssetImage(AppAssets.logo) as ImageProvider,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.memberName,
                style: AppTextStyles.font12BlackMedium,
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Image.asset(
                    AppAssets.user,
                    width: member.isHeadOfFamily ? 16.w : 12.w,
                    height: member.isHeadOfFamily ? 16.h : 12.h,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    member.level,
                    style: AppTextStyles.font12GreyRegular,
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 12.sp,
                    color: member.isActive ? Colors.green : Colors.red,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    displayStatus,
                    style: AppTextStyles.font12GreyRegular.copyWith(
                      color: member.isActive ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC107),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.r),
                    bottomRight: Radius.circular(8.r),
                  ),
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
                      style: AppTextStyles.font12BlackMedium.copyWith(
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
