import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/utils/app_button.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/attachments/succes_dialog.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/family_members_selector.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/note_text_field.dart';
import 'package:mediconsult/features/family_members/data/family_response_model.dart';
import 'package:mediconsult/features/refund/data/refund_types_reasons_models.dart';
import 'package:mediconsult/features/refund/presentation/cubit/refund_request_cubit.dart';
import 'package:mediconsult/features/refund/presentation/cubit/refund_request_state.dart';
import 'package:mediconsult/features/refund/presentation/widgets/add_attachment_widget.dart';
import 'package:mediconsult/features/refund/presentation/widgets/reason_selector.dart';
import 'package:mediconsult/features/refund/presentation/widgets/refund_form_fields.dart';
import 'package:mediconsult/features/refund/presentation/widgets/refund_type_selector.dart';
import 'package:mediconsult/shared/widgets/app_snack_bar.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:showcaseview/showcaseview.dart';
// ignore_for_file: deprecated_member_use

class RefundRequestScreen extends StatefulWidget {
  const RefundRequestScreen({super.key});

  @override
  State<RefundRequestScreen> createState() => _RefundRequestScreenState();
}

class _RefundRequestScreenState extends State<RefundRequestScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _providerController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _noteFocusNode = FocusNode();
  DateTime? _selectedDate;
  int? _selectedRefundTypeId;
  String? _selectedRefundTypeName;
  int? _selectedReasonId;
  FamilyMember? _selectedMember;
  List<String> _attachmentPaths = [];
  bool _hasAllRequiredAttachments = false;
  String? _noteError;
  String? _providerError;
  String? _amountError;
  List<RefundAttachment> _selectedRefundAttachments = [];

  // Showcase keys
  final GlobalKey _familyKey = GlobalKey();
  final GlobalKey _submitKey = GlobalKey();
  final GlobalKey _providerKey = GlobalKey();
  final GlobalKey _noteKey = GlobalKey();
  final GlobalKey _attachKey = GlobalKey();

  void _unfocusAll() {
    FocusScope.of(context).unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  void dispose() {
    _amountController.dispose();
    _providerController.dispose();
    _noteController.dispose();
    _amountFocusNode.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submitRefundRequest() async {
    // Clear previous errors
    setState(() {
      _noteError = null;
      _providerError = null;
      _amountError = null;
    });

    // Validation
    if (_selectedMember == null) {
      _showError('refund_request.validation.select_member'.tr());
      return;
    }
    if (_selectedRefundTypeId == null) {
      _showError('refund_request.validation.select_type'.tr());
      return;
    }
    final providerText = _providerController.text.trim();
    if (providerText.isEmpty) {
      final errorMsg = 'refund_request.validation.enter_provider'.tr();
      setState(() {
        _providerError = errorMsg;
      });
      _showError(errorMsg);
      return;
    }
    if (providerText.length < 2) {
      final errorMsg = 'refund_request.validation.provider_min_length'.tr();
      setState(() {
        _providerError = errorMsg;
      });
      _showError(errorMsg);
      return;
    }
    if (_selectedReasonId == null) {
      _showError('refund_request.validation.select_reason'.tr());
      return;
    }
    if (_amountController.text.trim().isEmpty) {
      final errorMsg = 'refund_request.validation.enter_amount'.tr();
      setState(() {
        _amountError = errorMsg;
      });
      _showError(errorMsg);
      return;
    }
    if (_selectedDate == null) {
      _showError('refund_request.validation.select_date'.tr());
      return;
    }

    // Validate notes character limit
    if (_noteController.text.length > 300) {
      final errorMsg = 'refund_request.validation.notes_too_long'.tr();
      setState(() {
        _noteError = errorMsg;
      });
      _showError(errorMsg);
      return;
    }

    // Validate date is within 60 days and not future
    final DateTime now = DateTime.now();
    final DateTime sixtyDaysAgo = now.subtract(const Duration(days: 60));
    if (_selectedDate!.isAfter(now)) {
      _showError('refund_request.validation.future_date_not_allowed'.tr());
      return;
    }
    if (_selectedDate!.isBefore(sixtyDaysAgo)) {
      _showError('refund_request.validation.date_too_old'.tr());
      return;
    }
    if (!_hasAllRequiredAttachments) {
      _showError('refund_request.validation.add_attachment'.tr());
      return;
    }

    final formattedDate = DateFormat('yyyy-MM-dd', 'en').format(_selectedDate!);
    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    if (amount < 1 || amount > 100000) {
      final errorMsg = 'refund_request.validation.amount_range'.tr();
      setState(() {
        _amountError = errorMsg;
      });
      _showError(errorMsg);
      return;
    }

    // Call cubit
    await context.read<RefundRequestCubit>().createRefundRequest(
      lang: context.locale.languageCode,
      memberId: _selectedMember!.memberId,
      refundTypeId: _selectedRefundTypeId!,
      refundReasonId: _selectedReasonId!,
      amount: amount,
      serviceDate: formattedDate,
      providerName: _providerController.text.trim(),
      notes: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      attachmentPaths: _attachmentPaths,
    );
  }

  void _showError(String message) {
    if (mounted) {
      HapticFeedback.lightImpact();
      showAppSnackBar(
        context,
        message,
        isError: true,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      HapticFeedback.selectionClick();
      showAppSnackBar(
        context,
        message,
        isError: false,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    _unfocusAll();

    await Future.delayed(const Duration(milliseconds: 50));

    final DateTime now = DateTime.now();
    final DateTime sixtyDaysAgo = now.subtract(const Duration(days: 60));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: sixtyDaysAgo,
      lastDate: now,
    );

    await Future.delayed(const Duration(milliseconds: 50));
    _unfocusAll();

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (context) => Scaffold(
        backgroundColor: AppColors.lightGreyClr,
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: _unfocusAll,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PageHeader(
                    title: 'refund_request.title'.tr(),
                    backPath: '/home',
                    onHelp: () {
                      // استخدام addPostFrameCallback للتأكد من بناء كل الـ widgets
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ShowCaseWidget.of(context).startShowCase([
                          _familyKey,
                          _providerKey,
                          _noteKey,
                          _attachKey,
                          _submitKey,
                        ]);
                      });
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
                                'refund_request.family_members'.tr(),
                                style: AppTextStyles.font14BlackMedium(context),
                              ),
                              SizedBox(height: 12.h),
                              Showcase(
                                key: _familyKey,
                                description: 'tutorial.family_members.select'
                                    .tr()
                                    .tr(),
                                child: FamilyMembersSelector(
                                  onMemberSelected: (member) {
                                    setState(() {
                                      _selectedMember = member;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 24.h),
                              Text(
                                'refund_request.refund_type'.tr(),
                                style: AppTextStyles.font14BlackMedium(context),
                              ),
                              SizedBox(height: 8.h),
                              GestureDetector(
                                onTap: _unfocusAll,
                                child: RefundTypeSelector(
                                  selectedTypeId: _selectedRefundTypeId,
                                  onTypeSelected: (type) {
                                    _unfocusAll();
                                    setState(() {
                                      _selectedRefundTypeId = type.id;
                                      _selectedRefundTypeName = type.name;
                                      _selectedRefundAttachments =
                                          type.attachments;
                                      _attachmentPaths = [];
                                      _hasAllRequiredAttachments = false;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'refund_request.provider'.tr(),
                                style: AppTextStyles.font14BlackMedium(context),
                              ),
                              SizedBox(height: 8.h),
                              Showcase(
                                key: _providerKey,
                                description: 'tutorial.provider.select'.tr(),
                                child: TextField(
                                  controller: _providerController,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    hintText: 'refund_request.provider_hint'
                                        .tr(),
                                    hintStyle: AppTextStyles.font14GreyRegular(
                                      context,
                                    ),
                                    errorText: _providerError,
                                    errorMaxLines: 2,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide(
                                        color: AppColors.greyClr.withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide(
                                        color: AppColors.greyClr.withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide(
                                        color: AppColors.primaryClr,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 12.h,
                                    ),
                                  ),
                                  style: AppTextStyles.font14BlackMedium(
                                    context,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      final text = value.trim();
                                      if (text.isEmpty) {
                                        _providerError =
                                            'refund_request.validation.enter_provider'
                                                .tr();
                                      } else if (text.length < 2) {
                                        _providerError =
                                            'refund_request.validation.provider_min_length'
                                                .tr();
                                      } else {
                                        _providerError = null;
                                      }
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'refund_request.reason'.tr(),
                                style: AppTextStyles.font14BlackMedium(context),
                              ),
                              SizedBox(height: 8.h),
                              GestureDetector(
                                onTap: _unfocusAll,
                                child: ReasonSelector(
                                  selectedReasonId: _selectedReasonId,
                                  onReasonSelected: (id, name) {
                                    _unfocusAll();
                                    setState(() {
                                      _selectedReasonId = id;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: RefundAmountField(
                                      controller: _amountController,
                                      focusNode: _amountFocusNode,
                                      errorText: _amountError,
                                      onChanged: (value) {
                                        setState(() {
                                          final text = value.trim();
                                          if (text.isEmpty) {
                                            _amountError =
                                                'refund_request.validation.enter_amount'
                                                    .tr();
                                          } else {
                                            final amount = double.tryParse(
                                              text,
                                            );
                                            if (amount == null ||
                                                amount < 1 ||
                                                amount > 100000) {
                                              _amountError =
                                                  'refund_request.validation.amount_range'
                                                      .tr();
                                            } else {
                                              _amountError = null;
                                            }
                                          }
                                        });
                                      },
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
                                'refund_request.note'.tr(),
                                style: AppTextStyles.font14BlackMedium(context),
                              ),
                              SizedBox(height: 8.h),
                              Showcase(
                                key: _noteKey,
                                description: 'tutorial.note.hint'.tr(),
                                child: NoteTextField(
                                  controller: _noteController,
                                  focusNode: _noteFocusNode,
                                  maxLength: 300,
                                  errorText: _noteError,
                                  onChanged: (value) {
                                    if (_noteError != null &&
                                        value.length <= 300) {
                                      setState(() {
                                        _noteError = null;
                                      });
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: 16.h),
                              // إظهار attachments section دايماً للـ showcase (مخفية لو مش محدد type)
                              Showcase(
                                key: _attachKey,
                                description: 'tutorial.attachments.hint'.tr(),
                                child: Visibility(
                                  visible:
                                      _selectedRefundTypeId != null &&
                                      _selectedRefundAttachments.isNotEmpty,
                                  maintainSize: false,
                                  maintainAnimation: false,
                                  maintainState: false,
                                  child:
                                      _selectedRefundTypeId != null &&
                                          _selectedRefundAttachments.isNotEmpty
                                      ? AddAttachmentWidget(
                                          key: ValueKey(_selectedRefundTypeId),
                                          refundTypeName:
                                              _selectedRefundTypeName,
                                          attachments:
                                              _selectedRefundAttachments,
                                          onAttachmentsChanged:
                                              (paths, hasAllRequired) {
                                                setState(() {
                                                  _attachmentPaths = paths;
                                                  _hasAllRequiredAttachments =
                                                      hasAllRequired;
                                                });
                                              },
                                          onAttachmentDialogClosed: _unfocusAll,
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Showcase(
                                key: _submitKey,
                                description: 'tutorial.submit.tap'.tr(),
                                child:
                                    BlocConsumer<
                                      RefundRequestCubit,
                                      RefundRequestState
                                    >(
                                      listener: (context, state) {
                                        state.maybeWhen(
                                          success: (data) {
                                            _showSuccess(
                                              'refund_request.success_message'
                                                  .tr(),
                                            );
                                            SuccessDialog.showRefund(context);
                                          },
                                          failed: (message) {
                                            _showError(message);
                                          },
                                          orElse: () {},
                                        );
                                      },
                                      builder: (context, state) {
                                        final isLoading = state.maybeWhen(
                                          loading: () => true,
                                          orElse: () => false,
                                        );
                                        return isLoading
                                            ? const CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                            : AppButton(
                                                onPressed: _submitRefundRequest,
                                                text: 'refund_request.submit'
                                                    .tr(),
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
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
