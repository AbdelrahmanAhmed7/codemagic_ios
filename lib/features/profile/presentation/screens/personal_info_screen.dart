import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:mediconsult/shared/widgets/form_fields/form_fields.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/features/profile/presentation/cubit/personal_info_cubit.dart';
import 'package:mediconsult/features/profile/presentation/cubit/personal_info_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mediconsult/core/widgets/image_shimmer.dart';
import 'package:mediconsult/core/constants/app_assets.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _insuranceIdController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _selectedGender = 'Male';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PersonalInfoCubit>().load(lang: context.locale.languageCode);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _insuranceIdController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _addressController.dispose();
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
            PageHeader(title: 'personal_info.title'.tr(), backPath: '/profile'),
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
                      child: BlocConsumer<PersonalInfoCubit, PersonalInfoState>(
                        listener: (context, state) {
                          if (state is Loaded) {
                            final d = state.data.data;
                            _nameController.text = d.memberName;
                            _insuranceIdController.text = d.memberId.toString();
                            _phoneController.text = d.mobile;
                            _dobController.text = d.birthdate;
                            _emailController.text = d.email;
                            _addressController.text = d.address;
                            _selectedGender = d.isMale ? 'Male' : 'Female';
                            setState(() {});
                          }
                        },
                        builder: (context, state) {
                          return ListView(
                            padding: EdgeInsets.all(16.w),
                            children: [
                              SizedBox(height: 24.h),
                              _buildProfilePhotoSection(state),
                              SizedBox(height: 32.h),
                              _buildFormFields(),
                              SizedBox(height: 24.h),
                            ],
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
  }

  Widget _buildProfilePhotoSection(PersonalInfoState state) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(shape: BoxShape.circle),
            clipBehavior: Clip.antiAlias,
            child: state is Loaded && state.data.data.image.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: state.data.data.image,
                    fit: BoxFit.cover,
                    memCacheWidth: 200,
                    memCacheHeight: 200,
                    maxWidthDiskCache: 200,
                    maxHeightDiskCache: 200,
                    cacheKey: state.data.data.image,
                    placeholder: (context, url) => const ImageShimmer.circle(),
                    errorWidget: (context, url, error) => Image.asset(
                      AppAssets.profile,
                      fit: BoxFit.cover,
                    ),
                  )
                : const ImageShimmer.circle(),
          ),
          SizedBox(height: 8.h),
          Text(
            'personal_info.profile_photo'.tr(),
            style: AppTextStyles.font14BlackMedium(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileAppTextField(
          label: 'personal_info.full_name'.tr(),
          readOnly: true,
          controller: _nameController,
          isRequired: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Full name is required';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        ProfileAppTextField(
          label: 'personal_info.insurance_card_id'.tr(),
          controller: _insuranceIdController,
          isRequired: true,
          readOnly: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Insurance Card ID is required';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        ProfileAppTextField(
          label: 'personal_info.phone_number'.tr(),
          controller: _phoneController,
          isRequired: true,
          keyboardType: TextInputType.phone,
          readOnly: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Phone number is required';
            }
            if (value.length < 11) {
              return 'Phone number must be at least 11 digits';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        AppDateField(
          label: 'personal_info.date_of_birth'.tr(),
          controller: _dobController,
          isRequired: true,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Date of birth is required';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        // Gender selector is readonly by default - no changes needed
        AppGenderSelector(
          selectedGender: _selectedGender,
          onGenderChanged: (gender) {
            // Disabled for readonly mode
            // setState(() {
            //   _selectedGender = gender;
            // });
          },
          isRequired: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Gender is required';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        ProfileAppTextField(
          label: 'personal_info.email_address'.tr(),
          readOnly: true,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Please enter a valid email address';
              }
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        ProfileAppTextField(
          label: 'personal_info.address'.tr(),
          readOnly: true,
          controller: _addressController,
          maxLines: 3,
        ),
      ],
    );
  }

  // void _savePersonalInfo() {
  //   if (_formKey.currentState!.validate()) {
  //     // Note: Only editable fields will be updated (Insurance Card ID, Phone Number, Date of Birth, and Gender are read-only)
  //     final personalInfo = {
  //       'fullName': _nameController.text.trim(),
  //       'insuranceCardId': _insuranceIdController.text.trim(), // Read-only
  //       'phoneNumber': _phoneController.text.trim(), // Read-only
  //       'dateOfBirth': _dobController.text.trim(), // Read-only
  //       'gender': _selectedGender, // Read-only
  //       'email': _emailController.text.trim(),
  //       'address': _addressController.text.trim(),
  //     };

  //     print('Saving personal info: $personalInfo');
  //     print('Note: Insurance Card ID, Phone Number, Date of Birth, and Gender are read-only fields');

  //     // Show success message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Personal information saved successfully!'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   }
  // }
}
