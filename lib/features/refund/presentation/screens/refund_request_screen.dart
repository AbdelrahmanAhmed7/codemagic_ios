import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/utils/app_button.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/attachments/succes_dialog.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/family_members_selector.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/provider_selector.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/note_text_field.dart';
import 'package:mediconsult/features/refund/presentation/widgets/add_attachment_widget.dart';
import 'package:mediconsult/features/refund/presentation/widgets/reason_selector.dart';
import 'package:mediconsult/features/refund/presentation/widgets/refund_type_selector.dart';
import 'package:mediconsult/features/refund/presentation/widgets/refund_form_fields.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:showcaseview/showcaseview.dart';
// ignore_for_file: deprecated_member_use

class RefundRequestScreen extends StatefulWidget {
  const RefundRequestScreen({super.key});

  @override
  State<RefundRequestScreen> createState() => _RefundRequestScreenState();
}

class _RefundRequestScreenState extends State<RefundRequestScreen> {
  bool _isLoading = false;
  final TextEditingController _amountController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedRefundType;

  // Showcase keys
  final GlobalKey _familyKey = GlobalKey();
  final GlobalKey _submitKey = GlobalKey();
  final GlobalKey _providerKey = GlobalKey();
  final GlobalKey _noteKey = GlobalKey();
  final GlobalKey _attachKey = GlobalKey();

  // TODO: API Integration
  // Method to handle refund request submission
  Future<void> _submitRefundRequest() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Replace with actual API call
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (context) => Scaffold(
        backgroundColor: AppColors.lightGreyClr,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageHeader(
                  title: 'Refund Request',
                  backPath: '/home',
                  onHelp: () {
                    ShowCaseWidget.of(context).startShowCase([
                      _familyKey,
                      _providerKey,
                      _noteKey,
                      _attachKey,
                      _submitKey,
                    ]);
                  },
                ),
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
                            Showcase(
                              key: _familyKey,
                              description: 'tutorial.family_members.select'
                                  .tr(),
                              child: const FamilyMembersSelector(),
                            ),
                            SizedBox(height: 24.h),
                            Text(
                              'Refund Type',
                              style: AppTextStyles.font14BlackMedium(context),
                            ),
                            SizedBox(height: 8.h),
                            RefundTypeSelector(
                              onChanged: (value) {
                                setState(() {
                                  _selectedRefundType = value;
                                });
                              },
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Provider',
                              style: AppTextStyles.font14BlackMedium(context),
                            ),
                            SizedBox(height: 8.h),
                            Showcase(
                              key: _providerKey,
                              description: 'tutorial.provider.select'.tr(),
                              child: const ProviderSelector(),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Reason',
                              style: AppTextStyles.font14BlackMedium(context),
                            ),
                            SizedBox(height: 8.h),
                            const ReasonSelector(),
                            SizedBox(height: 16.h),
                            Row(
                              children: [
                                Expanded(
                                  child: RefundAmountField(
                                    controller: _amountController,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: RefundDatePicker(
                                    selectedDate: _selectedDate,
                                    onTap: _selectDate,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Note',
                              style: AppTextStyles.font14BlackMedium(context),
                            ),
                            SizedBox(height: 8.h),
                            Showcase(
                              key: _noteKey,
                              description: 'tutorial.note.hint'.tr(),
                              child: const NoteTextField(maxLength: 300),
                            ),
                            SizedBox(height: 16.h),
                            Showcase(
                              key: _attachKey,
                              description: 'tutorial.attachments.hint'.tr(),
                              child: AddAttachmentWidget(
                                refundTypeName: _selectedRefundType,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Showcase(
                              key: _submitKey,
                              description: 'tutorial.submit.tap'.tr(),
                              child: SizedBox(
                                width: double.infinity,
                                height: 48.h,
                                child: _isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : AppButton(
                                        text: 'Submit',
                                        onPressed: _submitRefundRequest,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
