import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/attachments/attachment_item.dart';
import 'package:mediconsult/features/refund/data/refund_types_reasons_models.dart';
import 'package:mediconsult/core/utils/image_picker_service.dart';

class _UploadSelection {
  final ImageProvider imageProvider;
  final String name;

  _UploadSelection({required this.imageProvider, required this.name});
}

class AddAttachmentWidget extends StatefulWidget {
  const AddAttachmentWidget({
    super.key,
    this.refundTypeName,
    required this.attachments,
    this.onAttachmentsChanged,
    this.onAttachmentDialogClosed,
  });

  final String? refundTypeName;
  final List<RefundAttachment> attachments;
  final Function(List<String>, bool hasAllRequired)? onAttachmentsChanged;
  final VoidCallback? onAttachmentDialogClosed;

  @override
  State<AddAttachmentWidget> createState() => _AddAttachmentWidgetState();
}

class _AddAttachmentWidgetState extends State<AddAttachmentWidget> {
  late List<AttachmentItem?> _slotItems;
  late List<String?> _slotPaths;
  bool _showAttachmentOptions = false;

  @override
  void initState() {
    super.initState();
    _slotItems = List<AttachmentItem?>.filled(
      widget.attachments.length,
      null,
      growable: false,
    );
    _slotPaths = List<String?>.filled(
      widget.attachments.length,
      null,
      growable: false,
    );
  }

  @override
  void didUpdateWidget(covariant AddAttachmentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.attachments.length != widget.attachments.length) {
      _slotItems = List<AttachmentItem?>.filled(
        widget.attachments.length,
        null,
        growable: false,
      );
      _slotPaths = List<String?>.filled(
        widget.attachments.length,
        null,
        growable: false,
      );
    }
  }

  bool get _hasAnyAttachment => _slotItems.any((item) => item != null);

  bool get _hasAllRequiredAttachments {
    for (int i = 0; i < widget.attachments.length; i++) {
      final attachment = widget.attachments[i];
      if (attachment.isRequired && _slotPaths[i] == null) {
        return false;
      }
    }
    return widget.attachments.isNotEmpty;
  }

  void _notifyPathsChanged() {
    final paths = <String>[];
    for (final path in _slotPaths) {
      if (path != null) {
        paths.add(path);
      }
    }
    final hasAllRequired = _hasAllRequiredAttachments;
    widget.onAttachmentsChanged?.call(paths, hasAllRequired);
  }

  void _openUploadSheet(int index) async {
    FocusScope.of(context).unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    await Future.delayed(const Duration(milliseconds: 50));

    final selection = await showModalBottomSheet<_UploadSelection>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.whiteClr,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 36.w,
                    height: 4.h,
                    margin: EdgeInsets.only(bottom: 12.h),
                    decoration: BoxDecoration(
                      color: AppColors.lightGreyClr,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildUploadOption(
                          AppAssets.camera,
                          'add_attachment.take_photo'.tr(),
                          () async {
                            final picked =
                                await ImagePickerService.pickFromCameraWithPermission();
                            if (picked != null) {
                              // Auto-upload: close modal immediately with selection
                              String path = picked.path;
                              _slotPaths[index] = path;
                              Navigator.of(context).pop(
                                _UploadSelection(
                                  imageProvider: FileImage(File(path)),
                                  name: picked.name,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildUploadOption(
                          AppAssets.upload,
                          'add_attachment.upload_file'.tr(),
                          () async {
                            final picked =
                                await ImagePickerService.pickFromGallery();
                            if (picked != null) {
                              // Auto-upload: close modal immediately with selection
                              String path = picked.path;
                              _slotPaths[index] = path;
                              Navigator.of(context).pop(
                                _UploadSelection(
                                  imageProvider: FileImage(File(path)),
                                  name: picked.name,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // إزالة الـ focus فوراً بعد إغلاق الـ bottom sheet
    FocusScope.of(context).unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    
    // استدعاء الـ callback لإزالة الـ focus بعد إغلاق الـ dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onAttachmentDialogClosed?.call();
    });

    if (selection == null) return;
    setState(() {
      final path = _slotPaths[index];
      final item = AttachmentItem(
        image: selection.imageProvider,
        name: selection.name,
        path: path ?? '',
      );
      _slotItems[index] = item;
      _notifyPathsChanged();
    });
  }

  Widget _buildUploadOption(
    String assetIcon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.lightGreyClr,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              assetIcon,
              width: 48.w,
              height: 48.w,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 8.h),
            Text(label, style: AppTextStyles.font14BlackMedium(context)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteClr,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.greyClr.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add Attachments button
          GestureDetector(
            onTap: () {
              setState(() {
                _showAttachmentOptions = !_showAttachmentOptions;
              });
            },
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: _hasAnyAttachment
                        ? AppColors.successClr
                        : AppColors.primaryClr,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _hasAnyAttachment ? Icons.check : Icons.add,
                    color: AppColors.whiteClr,
                    size: 18,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'placeholders.add_attachment'.tr(),
                          style: AppTextStyles.font14BlackMedium(context),
                        ),
                        TextSpan(
                          text: ' (${'approval_request.max_size'.tr()})',
                          style: AppTextStyles.font10GreyRegular(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_showAttachmentOptions) ...[
            SizedBox(height: 16.h),
            Center(
              child: Text(
                '${widget.refundTypeName ?? ' '} ${'add_attachment.attachment'.tr()}',
                style: AppTextStyles.font14BlackMedium(context),
              ),
            ),
            SizedBox(height: 12.h),
            // كروت رفع ديناميكية بعدد المرفقات القادمة من الـ API
            ...List.generate(widget.attachments.length, (index) {
              final attachment = widget.attachments[index];
              final item = _slotItems[index];
              final hasFile = item != null;

              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: GestureDetector(
                  onTap: () => _openUploadSheet(index),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 73.w,
                        height: 59.h,
                        decoration: BoxDecoration(
                          color: AppColors.lightGreyClr,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: (item == null)
                            ? Image.asset(
                                AppAssets.uploadIcon,
                                fit: BoxFit.contain,
                              )
                            : Image(image: item.image, fit: BoxFit.cover),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              attachment.isRequired
                                  ? '${attachment.title} *'
                                  : attachment.title,
                              style: AppTextStyles.font12BlueRegular(context),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            hasFile
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: hasFile
                                ? AppColors.successClr
                                : AppColors.greyClr,
                          ),
                          if (hasFile) ...[
                            SizedBox(width: 8.w),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: AppColors.errorClr,
                              ),
                              onPressed: () => _confirmDelete(index),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],

          // No separate list; previews shown inline above per UX
        ],
      ),
    );
  }

  void _confirmDelete(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 24.h,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Image.asset(
                  AppAssets.delete,
                  width: 177.w,
                  height: 111.h,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 22.h),
              Text(
                'Delete Attachment',
                style: AppTextStyles.font14BlackMedium(context),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'Are you sure you want to delete this file permanently?',
                style: AppTextStyles.font10GreyRegular(context),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 39.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.lightGreyClr),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        'Cancel',
                        style: AppTextStyles.font14BlackMedium(context),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errorClr,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        'Delete',
                        style: AppTextStyles.font14WhiteMedium(context),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (confirmed == true) {
      setState(() {
        _slotItems[index] = null;
        _slotPaths[index] = null;
      });
      _notifyPathsChanged();
    }
  }
}
