import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/utils/app_button.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:mediconsult/shared/widgets/form_fields/form_fields.dart';

class AddFamilyMemberScreen extends StatefulWidget {
  const AddFamilyMemberScreen({super.key});

  @override
  State<AddFamilyMemberScreen> createState() => _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState extends State<AddFamilyMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String _selectedRelationship = 'spouse';
  String _selectedGender = 'male';

  @override
  void dispose() {
    _nameController.dispose();
    _nationalIdController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyClr,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(title: 'family_members.add_member'.tr(), backPath: '/family-members'),
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildProfilePhotoSection(),
                                  SizedBox(height: 16.h),
                                  _buildFormFields(),
                                ],
                              ),
                            ),
                          ),
                          _buildButtons(),
                        ],
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


  Widget _buildProfilePhotoSection() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.lightGreyClr,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.person, size: 50.sp, color: AppColors.greyClr),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryClr,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.whiteClr, width: 2),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: AppColors.whiteClr,
                      size: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Text('family_members.add_member_photo'.tr(), style: AppTextStyles.font14BlackMedium(context)),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileAppTextField(
          label: 'family_members.full_name'.tr(),
          controller: _nameController,
          isRequired: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'family_members.validation.full_name_required'.tr();
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        ProfileAppTextField(
          label: 'family_members.national_id'.tr(),
          controller: _nationalIdController,
          isRequired: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'family_members.validation.national_id_required'.tr();
            }
            if (value.length < 14) {
              return 'family_members.validation.national_id_length'.tr();
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        AppDateField(
          label: 'family_members.date_of_birth'.tr(),
          controller: _dobController,
          isRequired: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'family_members.validation.dob_required'.tr();
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        AppDropdownField<String>(
          label: 'family_members.relationship'.tr(),
          value: _selectedRelationship,
          items: [
            DropdownMenuItem(value: 'spouse', child: Text('family_members.relationships.spouse'.tr())),
            DropdownMenuItem(value: 'son', child: Text('family_members.relationships.son'.tr())),
            DropdownMenuItem(value: 'daughter', child: Text('family_members.relationships.daughter'.tr())),
            DropdownMenuItem(value: 'parent', child: Text('family_members.relationships.parent'.tr())),
          ],
          onChanged: (value) {
            setState(() {
              _selectedRelationship = value!;
            });
          },
          isRequired: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'family_members.validation.relationship_required'.tr();
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        AppGenderSelector(
          selectedGender: _selectedGender,
          onGenderChanged: (gender) {
            setState(() {
              _selectedGender = gender;
            });
          },
          isRequired: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'family_members.validation.gender_required'.tr();
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          AppButton(
            text: 'family_members.add_member'.tr(),
            onPressed: _addFamilyMember,
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  side: BorderSide(color: AppColors.greyClr),
                ),
              ),
              child: Text('family_members.cancel'.tr(), style: AppTextStyles.font14BlackMedium(context)),
            ),
          ),
        ],
      ),
    );
  }

  void _addFamilyMember() {
    if (_formKey.currentState!.validate()) {
      final familyMember = {
        'fullName': _nameController.text.trim(),
        'nationalId': _nationalIdController.text.trim(),
        'dateOfBirth': _dobController.text.trim(),
        'relationship': _selectedRelationship,
        'gender': _selectedGender,
      };
      
      print('Adding family member: $familyMember');
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('family_members.success_message'.tr()),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navigate back
      Navigator.pop(context);
    }
  }
}