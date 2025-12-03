import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/utils/app_button.dart';
import 'package:mediconsult/features/approval_request/presentation/cubit/approval_request_cubit.dart';
import 'package:mediconsult/features/approval_request/presentation/cubit/approval_request_state.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/attachments/succes_dialog.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/attachments_section.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/family_members_selector.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/note_text_field.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/provider_selector.dart';
import 'package:mediconsult/features/family_members/data/family_response_model.dart';
import 'package:mediconsult/features/providers/data/providers_models.dart';
import 'package:mediconsult/shared/widgets/app_snack_bar.dart';
import 'package:mediconsult/shared/widgets/page_header.dart';
import 'package:mediconsult/shared/widgets/custom_showcase.dart';
import 'package:mediconsult/core/cache/cache_service.dart';
// ignore_for_file: deprecated_member_use

class ApprovalRequestScreen extends StatefulWidget {
  const ApprovalRequestScreen({super.key});

  @override
  State<ApprovalRequestScreen> createState() => _ApprovalRequestScreenState();
}

class _ApprovalRequestScreenState extends State<ApprovalRequestScreen> {
  FamilyMember? _selectedFamilyMember;
  ProviderItem? _selectedProvider;
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _noteFocusNode = FocusNode();
  final List<String> _attachments = [];
  String? _noteError;

  // Showcase keys
  final GlobalKey _familyKey = GlobalKey();
  final GlobalKey _submitKey = GlobalKey();
  final GlobalKey _providerKey = GlobalKey();
  final GlobalKey _noteKey = GlobalKey();
  final GlobalKey _attachKey = GlobalKey();
  
  // Showcase state
  int _showcaseIndex = -1;

  @override
  void dispose() {
    _noteController.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  // Method to handle approval request submission
  Future<void> _submitApprovalRequest() async {
    // Clear previous errors
    setState(() {
      _noteError = null;
    });

    // Validation
    if (_selectedFamilyMember == null) {
      _showError('approval_request.validation.select_member'.tr());
      return;
    }

    if (_selectedProvider == null) {
      _showError('approval_request.validation.select_provider'.tr());
      return;
    }

    // Validate notes character limit
    if (_noteController.text.length > 300) {
      setState(() {
        _noteError = 'approval_request.validation.notes_too_long'.tr();
      });
      return;
    }

    if (_attachments.isEmpty) {
      _showError('approval_request.validation.attachment_required'.tr());
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


  void _showError(String message) {
    if (mounted) {
      HapticFeedback.lightImpact();
      showAppSnackBar(
        context,
        message,
        isError: true,
        duration: const Duration(seconds: 4),
      );
    }
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

  void _startShowcase() {
    setState(() {
      _showcaseIndex = 0;
    });
  }

  void _nextShowcase() {
    if (_showcaseIndex < _showcaseKeys.length - 1) {
      setState(() {
        _showcaseIndex++;
      });
    } else {
      _dismissShowcase();
    }
  }

  void _dismissShowcase() {
    setState(() {
      _showcaseIndex = -1;
    });
  }

  List<GlobalKey> get _showcaseKeys => [
        _familyKey,
        _providerKey,
        _noteKey,
        _attachKey,
        _submitKey,
      ];

  List<String> get _showcaseDescriptions => [
        'tutorial.family_members.select'.tr(),
        'tutorial.provider.select'.tr(),
        'tutorial.note.hint'.tr(),
        'tutorial.attachments.hint'.tr(),
        'tutorial.submit.tap'.tr(),
      ];

  @override
  Widget build(BuildContext context) {
    return CustomShowcaseOverlay(
      targetKeys: _showcaseKeys,
      descriptions: _showcaseDescriptions,
      currentIndex: _showcaseIndex,
      onNext: _nextShowcase,
      onDismiss: _dismissShowcase,
      child: Scaffold(
        backgroundColor: AppColors.lightGreyClr,
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: Column(
              children: [
                PageHeader(
                  title: 'approval_request.title'.tr(),
                  backPath: '/approval-history',
                  onHelp: () {
                    FocusScope.of(context).unfocus();
                    FocusManager.instance.primaryFocus?.unfocus();
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    _startShowcase();
                  },
                ),
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
                                    color: AppColors.greyClr.withValues(
                                      alpha: 0.08,
                                    ),
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
                                      'approval_request.family_members'.tr(),
                                      style: AppTextStyles.font14BlackMedium(
                                        context,
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    CustomShowcase(
                                      key: _familyKey,
                                      targetKey: _familyKey,
                                      child: FamilyMembersSelector(
                                        onMemberSelected: (member) {
                                          setState(() {
                                            _selectedFamilyMember = member;
                                          });
                                        },
                                        selectedMember: _selectedFamilyMember,
                                      ),
                                    ),
                                    SizedBox(height: 24.h),
                                    Text(
                                      'approval_request.provider'.tr(),
                                      style: AppTextStyles.font14BlackMedium(
                                        context,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    CustomShowcase(
                                      key: _providerKey,
                                      targetKey: _providerKey,
                                      child: ProviderSelector(
                                        onProviderSelected: (provider) {
                                          setState(() {
                                            _selectedProvider = provider;
                                          });
                                        },
                                        selectedProvider: _selectedProvider,
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      'approval_request.note'.tr(),
                                      style: AppTextStyles.font14BlackMedium(
                                        context,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    CustomShowcase(
                                      key: _noteKey,
                                      targetKey: _noteKey,
                                      child: NoteTextField(
                                        maxLength: 300,
                                        controller: _noteController,
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
                                    SizedBox(height: 21.h),
                                    CustomShowcase(
                                      key: _attachKey,
                                      targetKey: _attachKey,
                                      child: AttachmentsSection(
                                        onAttachmentsChanged: (attachments) {
                                          setState(() {
                                            _attachments.clear();
                                            _attachments.addAll(attachments);
                                          });
                                          Future.delayed(
                                            const Duration(milliseconds: 300),
                                            () {
                                              if (mounted) {
                                                FocusScope.of(
                                                  context,
                                                ).unfocus();
                                                FocusManager
                                                    .instance
                                                    .primaryFocus
                                                    ?.unfocus();
                                                SystemChannels.textInput
                                                    .invokeMethod(
                                                      'TextInput.hide',
                                                    );
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    CustomShowcase(
                                      key: _submitKey,
                                      targetKey: _submitKey,
                                      child:
                                          BlocConsumer<
                                            ApprovalRequestCubit,
                                            ApprovalRequestState
                                          >(
                                            listener: (context, state) {
                                              state.when(
                                                initial: () {},
                                                loading: () {},
                                                success: (data) {
                                                  // Clear home cache to force refresh when user returns to home
                                                  // This ensures HomeCubit will fetch fresh data instead of using cache
                                                  CacheService.clearCache();
                                                  // Show success dialog
                                                  SuccessDialog.show(context);
                                                  _resetForm();
                                                },
                                                failed: (message) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(message),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            builder: (context, state) {
                                              final isLoading =
                                                  state is Loading;
                                              return AppButton(
                                                text: 'common.save'.tr(),
                                                onPressed:
                                                    _submitApprovalRequest,
                                                isLoading: isLoading,
                                                width: double.infinity,
                                              );
                                            },
                                          ),
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
        ),
      ),
    );
  }
}
