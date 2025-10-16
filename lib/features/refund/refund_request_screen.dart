import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/utils/app_button.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/attachments/succes_dialog.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/family_members_selector.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/provider_selector.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/note_text_field.dart';
import 'package:mediconsult/features/refund/widgets/add_attachment_widget.dart';
import 'package:mediconsult/features/refund/widgets/reason_selector.dart';
import 'package:mediconsult/features/refund/widgets/refund_type_selector.dart';

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
    return Scaffold(
      backgroundColor: AppColors.lightGreyClr,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 136.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryClr,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                  child: Row(
                    children: [
                      Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: AppColors.whiteClr,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.greyClr.withValues(alpha: 0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                          onPressed: () => context.go('/home'),
                        ),
                      ),
                      SizedBox(width: 28.w),
                      Expanded(
                        child: Text(
                          'Refund Request',
                          style: AppTextStyles.font18BlackSemiBold.copyWith(
                            color: AppColors.whiteClr,
                          ),
                        ),
                      ),
                      Container(
                        width: 28.w,
                        height: 28.w,
                        decoration: const BoxDecoration(
                          color: AppColors.whiteClr,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.question,
                          color: AppColors.blackClr,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
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
                            style: AppTextStyles.font14BlackMedium,
                          ),
                          SizedBox(height: 12.h),
                          const FamilyMembersSelector(),
                          SizedBox(height: 24.h),
                          Text(
                            'Refund Type',
                            style: AppTextStyles.font14BlackMedium,
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
                            style: AppTextStyles.font14BlackMedium,
                          ),
                          SizedBox(height: 8.h),
                          const ProviderSelector(),
                          SizedBox(height: 16.h),
                          Text(
                            'Reason',
                            style: AppTextStyles.font14BlackMedium,
                          ),
                          SizedBox(height: 8.h),
                          const ReasonSelector(),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Amount',
                                      style: AppTextStyles.font14BlackMedium,
                                    ),
                                    SizedBox(height: 8.h),
                                    TextField(
                                      controller: _amountController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'Enter amount',
                                        hintStyle:
                                            AppTextStyles.font14GreyRegular,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 8.h,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppColors.greyClr.withValues(
                                              alpha: 0.2,
                                            ),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          borderSide: BorderSide(
                                            color: AppColors.greyClr.withValues(
                                              alpha: 0.2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Service Date',
                                      style: AppTextStyles.font14BlackMedium,
                                    ),
                                    SizedBox(height: 8.h),
                                    GestureDetector(
                                      onTap: () => _selectDate(context),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 12.h,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColors.greyClr.withValues(
                                              alpha: 0.2,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _selectedDate == null
                                                  ? 'Select date'
                                                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                              style: _selectedDate == null
                                                  ? AppTextStyles
                                                        .font14GreyRegular
                                                  : AppTextStyles
                                                        .font14BlackMedium,
                                            ),
                                            Icon(
                                              Icons.calendar_today_outlined,
                                              size: 20.w,
                                              color: AppColors.greyClr,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Text('Note', style: AppTextStyles.font14BlackMedium),
                          SizedBox(height: 8.h),
                          const NoteTextField(maxLength: 300),
                          SizedBox(height: 16.h),
                          AddAttachmentWidget(refundTypeName: _selectedRefundType),
                          SizedBox(height: 20.h),
                          SizedBox(
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
    );
  }
}
