import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/attachments/succes_dialog.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/family_members_selector.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/provider_selector.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/note_text_field.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/attachments_section.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/features/approval_request/presentation/cubit/approval_request_cubit.dart';
import 'package:mediconsult/features/approval_request/presentation/cubit/approval_request_state.dart';
import 'package:mediconsult/features/family_members/data/family_response_model.dart';
import 'package:mediconsult/features/providers/data/providers_models.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:mediconsult/core/utils/app_button.dart';

class ApprovalRequestScreen extends StatefulWidget {
  const ApprovalRequestScreen({super.key});

  @override
  State<ApprovalRequestScreen> createState() => _ApprovalRequestScreenState();
}

class _ApprovalRequestScreenState extends State<ApprovalRequestScreen> {
  FamilyMember? _selectedFamilyMember;
  ProviderItem? _selectedProvider;
  final TextEditingController _noteController = TextEditingController();
  final List<String> _attachments = [];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  // Method to handle approval request submission
  Future<void> _submitApprovalRequest() async {
    // Validation
    if (_selectedFamilyMember == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a family member')),
      );
      return;
    }

    if (_selectedProvider == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a provider')),
      );
      return;
    }

    if (_attachments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least 1 attachment is required')),
      );
      return;
    }

    // Submit approval request
    context.read<ApprovalRequestCubit>().createApprovalRequest(
      lang: context.locale.languageCode,
      memberId: _selectedFamilyMember!.memberId,
      providerId: _selectedProvider!.id,
      notes: _noteController.text.isNotEmpty ? _noteController.text : null,
      attachmentPaths: _attachments,
    );
  }

  void _resetForm() {
    setState(() {
      _selectedFamilyMember = null;
      _selectedProvider = null;
      _noteController.clear();
      _attachments.clear();
    });
    context.read<ApprovalRequestCubit>().reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyClr,
      body: SafeArea(
        child: Column(
            children: [
              const PageHeader(title: 'Approval Request', backPath: '/approval-history'),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Transform.translate(
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
                            child: Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Family Members',
                                    style: AppTextStyles.font14BlackMedium(context),
                                  ),
                                  SizedBox(height: 12.h),
                                  FamilyMembersSelector(
                                    onMemberSelected: (member) {
                                      setState(() {
                                        _selectedFamilyMember = member;
                                      });
                                    },
                                    selectedMember: _selectedFamilyMember,
                                  ),
                                  SizedBox(height: 24.h),
                                  Text(
                                    'Provider',
                                    style: AppTextStyles.font14BlackMedium(context),
                                  ),
                                  SizedBox(height: 8.h),
                                  ProviderSelector(
                                    onProviderSelected: (provider) {
                                      setState(() {
                                        _selectedProvider = provider;
                                      });
                                    },
                                    selectedProvider: _selectedProvider,
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'Note',
                                    style: AppTextStyles.font14BlackMedium(context),
                                  ),
                                  SizedBox(height: 8.h),
                                  NoteTextField(
                                    maxLength: 300,
                                    controller: _noteController,
                                  ),
                                  SizedBox(height: 21.h),
                                  AttachmentsSection(
                                    onAttachmentsChanged: (attachments) {
                                      setState(() {
                                        _attachments.clear();
                                        _attachments.addAll(attachments);
                                      });
                                    },
                                  ),
                                  SizedBox(height: 20.h),
                                  BlocConsumer<ApprovalRequestCubit, ApprovalRequestState>(
                                    listener: (context, state) {
                                      state.when(
                                        initial: () {},
                                        loading: () {},
                                        success: (data) {
                                          SuccessDialog.show(context);
                                          _resetForm();
                                        },
                                        failed: (message) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(message),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    builder: (context, state) {
                                      final isLoading = state is Loading;
                                      return AppButton(
                                        text: 'Save',
                                        onPressed: _submitApprovalRequest,
                                        isLoading: isLoading,
                                        width: double.infinity,
                                      );
                                    },
                                  ),
                                  SizedBox(height: 20.h),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}