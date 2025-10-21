import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/utils/app_button.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/attachments/succes_dialog.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/family_members_selector.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/provider_selector.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/note_text_field.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/attachments_section.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/approval_empty_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconsult/features/approval_request/presentation/cubit/approval_cubit.dart';
import 'package:mediconsult/features/approval_request/presentation/cubit/approval_state.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';

class ApprovalRequestScreen extends StatefulWidget {
  const ApprovalRequestScreen({super.key});

  @override
  State<ApprovalRequestScreen> createState() => _ApprovalRequestScreenState();
}

class _ApprovalRequestScreenState extends State<ApprovalRequestScreen> {
  bool _isLoading = false;

  // TODO: API Integration
  // Method to handle approval request submission
  Future<void> _submitApprovalRequest() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Replace with actual API call
      // Example:
      // final response = await approvalRepository.submitRequest(
      //   familyMemberId: selectedFamilyMemberId,
      //   providerId: selectedProviderId,
      //   note: noteController.text,
      //   attachments: attachmentsList,
      // );
      // 
      // if (response.isSuccess) {
      //   if (mounted) {
      //     SuccessDialog.show(context);
      //   }
      // } else {
      //   // Show error snackbar or dialog
      //   if (mounted) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text(response.message)),
      //     );
      //   }
      // }

      // Temporary: Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        SuccessDialog.show(context);
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasHistory = false; // TODO: bind to real data
    return Scaffold(
      backgroundColor: AppColors.lightGreyClr,
      body: SafeArea(
        child: BlocProvider(
          create: (_) => ApprovalCubit(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              const PageHeader(title: 'Approval Request', backPath: '/home'),
              BlocBuilder<ApprovalCubit, ApprovalState>(
                builder: (context, state) {
                  final isFormMode = state is ApprovalFormMode;
                  final showEmpty = state is ApprovalEmpty;
                  return Column(children: [
                    if (showEmpty)
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
                              child: ApprovalEmptyState(
                                onCreate: () => context.read<ApprovalCubit>().openForm(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (isFormMode)
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
                                    style: AppTextStyles.font14BlackMedium,
                                  ),
                                  SizedBox(height: 12.h),
                                  const FamilyMembersSelector(),
                                  SizedBox(height: 24.h),
                                  Text(
                                    'Provider',
                                    style: AppTextStyles.font14BlackMedium,
                                  ),
                                  SizedBox(height: 8.h),
                                  const ProviderSelector(),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'Note',
                                    style: AppTextStyles.font14BlackMedium,
                                  ),
                                  SizedBox(height: 8.h),
                                  const NoteTextField(maxLength: 300),
                                  SizedBox(height: 21.h),
                                  const AttachmentsSection(),
                                  SizedBox(height: 20.h),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 48.h,
                                    child: _isLoading
                                        ? const Center(child: CircularProgressIndicator())
                                        : AppButton(
                                            text: 'Submit',
                                            onPressed: _submitApprovalRequest,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ]);
                },
              ),
              if (hasHistory)
                // TODO: approval history list here later
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    ),
    );
  }
}