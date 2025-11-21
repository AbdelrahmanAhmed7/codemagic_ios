import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/family_members/presentation/cubit/family_members_cubit.dart';
import 'package:mediconsult/features/family_members/presentation/cubit/family_members_state.dart';
import 'package:mediconsult/features/family_members/data/family_response_model.dart';

class FamilyMembersSelector extends StatefulWidget {
  final Function(FamilyMember?)? onMemberSelected;
  final FamilyMember? selectedMember;

  const FamilyMembersSelector({
    super.key,
    this.onMemberSelected,
    this.selectedMember,
  });

  @override
  State<FamilyMembersSelector> createState() => _FamilyMembersSelectorState();
}

class _FamilyMembersSelectorState extends State<FamilyMembersSelector> {
  FamilyMember? _selectedMember;

  @override
  void initState() {
    super.initState();
    _selectedMember = widget.selectedMember;    
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.read<FamilyMembersCubit>().state is! Loaded) {
      context.read<FamilyMembersCubit>().getFamilyMembers(context.locale.languageCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FamilyMembersCubit, FamilyMembersState>(
      builder: (context, state) {
        return state.when(
          initial: () => _buildLoading(),
          loading: () => _buildLoading(),
          loaded: (response) {
            final members = response.data.familyMembers;
            
            // Auto-select first member if none selected
            if (_selectedMember == null && members.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _selectedMember = members.first;
                });
                widget.onMemberSelected?.call(_selectedMember);
              });
            }
            
            return _buildMembersList(members);
          },
          failed: (message) => _buildError(message),
        );
      },
    );
  }

  Widget _buildLoading() {
    return SizedBox(
      height: 80.h,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildError(String message) {
    return SizedBox(
      height: 80.h,
      child: Center(
        child: Text(
          'Error loading family members',
          style: AppTextStyles.font12GreyRegular(context),
        ),
      ),
    );
  }

  Widget _buildMembersList(List<FamilyMember> members) {
    if (members.isEmpty) {
      return SizedBox(
        height: 80.h,
        child: Center(
          child: Text(
            'No family members found',
            style: AppTextStyles.font12GreyRegular(context),
          ),
        ),
      );
    }

    return SizedBox(
      height: 80.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: members.map((member) => _buildMemberItem(member)).toList(),
      ),
    );
  }

  Widget _buildMemberItem(FamilyMember member) {
    final isSelected = _selectedMember?.memberId == member.memberId;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMember = member;
        });
        widget.onMemberSelected?.call(member);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primaryClr : Colors.transparent,
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primaryClr.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: ClipOval(
              child: member.memberImage != null && member.memberImage!.isNotEmpty
                  ? Image.network(
                      member.memberImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.lightGreyClr,
                          child: Icon(
                            Icons.person,
                            color: AppColors.greyClr,
                            size: 24.w,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: AppColors.lightGreyClr,
                      child: Icon(
                        Icons.person,
                        color: AppColors.greyClr,
                        size: 24.w,
                      ),
                    ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            member.memberName,
            style: isSelected 
                ? AppTextStyles.font12BlueMedium(context)
                : AppTextStyles.font12GreyRegular(context),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

