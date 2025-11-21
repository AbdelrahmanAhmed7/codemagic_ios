import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/utils/app_button.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/attachments/attachment_item.dart';
import 'package:mediconsult/core/utils/image_picker_service.dart';

enum _AttachmentSlot { eInvoice, prescription }

class _UploadSelection {
  final ImageProvider imageProvider;
  final String name;

  _UploadSelection({required this.imageProvider, required this.name});
}

class AddAttachmentWidget extends StatefulWidget {
  const AddAttachmentWidget({
    super.key,
    this.refundTypeName,
    this.onAttachmentsChanged,
  });

  final String? refundTypeName;
  final Function(List<String>, bool, bool)? onAttachmentsChanged;

  @override
  State<AddAttachmentWidget> createState() => _AddAttachmentWidgetState();
}

class _AddAttachmentWidgetState extends State<AddAttachmentWidget> {
  final List<AttachmentItem> _attachments = [];
  bool _showAttachmentOptions = false;
  AttachmentItem? _eInvoice;
  AttachmentItem? _prescription;
  String? _eInvoicePath;
  String? _prescriptionPath;

  void _notifyPathsChanged() {
    final paths = <String>[
      if (_eInvoicePath != null) _eInvoicePath!,
      if (_prescriptionPath != null) _prescriptionPath!,
    ];
    final hasInvoice = _eInvoicePath != null;
    final hasPrescription = _prescriptionPath != null;
    widget.onAttachmentsChanged?.call(paths, hasInvoice, hasPrescription);
  }

  void _openUploadSheet(_AttachmentSlot slot) async {
    ImageProvider? previewCameraImage;
    String? previewCameraName;
    ImageProvider? previewGalleryImage;
    String? previewGalleryName;

    final selection = await showModalBottomSheet<_UploadSelection>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                            child: (previewCameraImage == null)
                                ? _buildUploadOption(
                                    AppAssets.camera,
                                    'add_attachment.take_photo'.tr(),
                                    () async {
                                      final picked =
                                          await ImagePickerService.pickFromCameraWithPermission();
                                      if (picked != null) {
                                        setModalState(() {
                                          previewCameraImage = FileImage(
                                            File(picked.path),
                                          );
                                          previewCameraName = picked.name;
                                        });
                                        // Store path for later use
                                        if (slot == _AttachmentSlot.eInvoice) {
                                          _eInvoicePath = picked.path;
                                        } else {
                                          _prescriptionPath = picked.path;
                                        }
                                      }
                                    },
                                  )
                                : Column(
                                    children: [
                                      Container(
                                        height: 150.h,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: AppColors.lightGreyClr,
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Image(
                                          image: previewCameraImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        previewCameraName ?? 'selected',
                                        style: AppTextStyles.font14BlackMedium(
                                          context,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: (previewGalleryImage == null)
                                ? _buildUploadOption(
                                    AppAssets.upload,
                                    'add_attachment.upload_file'.tr(),
                                    () async {
                                      final picked =
                                          await ImagePickerService.pickFromGallery();
                                      if (picked != null) {
                                        setModalState(() {
                                          previewGalleryImage = FileImage(
                                            File(picked.path),
                                          );
                                          previewGalleryName = picked.name;
                                        });
                                        // Store path for later use
                                        if (slot == _AttachmentSlot.eInvoice) {
                                          _eInvoicePath = picked.path;
                                        } else {
                                          _prescriptionPath = picked.path;
                                        }
                                      }
                                    },
                                  )
                                : Column(
                                    children: [
                                      Container(
                                        height: 150.h,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: AppColors.lightGreyClr,
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Image(
                                          image: previewGalleryImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        previewGalleryName ?? 'selected',
                                        style: AppTextStyles.font14BlackMedium(
                                          context,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.infinity,
                        height: 44.h,
                        child: AppButton(
                          text: 'Upload',
                          onPressed: () {
                            final img =
                                previewCameraImage ?? previewGalleryImage;
                            final name =
                                previewCameraName ?? previewGalleryName;
                            if (img != null && name != null) {
                              Navigator.of(context).pop(
                                _UploadSelection(
                                  imageProvider: img,
                                  name: name,
                                ),
                              );
                            } else {
                              Navigator.of(context).pop(null);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (selection == null) return;
    setState(() {
      final path = slot == _AttachmentSlot.eInvoice
          ? _eInvoicePath
          : _prescriptionPath;
      final item = AttachmentItem(
        image: selection.imageProvider,
        name: selection.name,
        path: path ?? '',
      );
      if (slot == _AttachmentSlot.eInvoice) {
        _eInvoice = item;
      } else {
        _prescription = item;
      }
      _attachments
        ..clear()
        ..addAll([
          if (_eInvoice != null) _eInvoice!,
          if (_prescription != null) _prescription!,
        ]);
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
                    color: _attachments.isNotEmpty
                        ? AppColors.successClr
                        : AppColors.primaryClr,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _attachments.isNotEmpty ? Icons.check : Icons.add,
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
            GestureDetector(
              onTap: () => _openUploadSheet(_AttachmentSlot.eInvoice),
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
                    child: (_eInvoice == null)
                        ? Image.asset(AppAssets.uploadIcon, fit: BoxFit.contain)
                        : Image(image: _eInvoice!.image, fit: BoxFit.cover),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'add_attachment.upload_e_invoice'.tr(),
                          style: AppTextStyles.font12BlueRegular(context),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'add_attachment.e_invoice_instructions'.tr(),
                          style: AppTextStyles.font8GreyRegular(context),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    _eInvoice != null
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: _eInvoice != null
                        ? AppColors.successClr
                        : AppColors.greyClr,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () => _openUploadSheet(_AttachmentSlot.prescription),
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
                    child: (_prescription == null)
                        ? Image.asset(AppAssets.uploadIcon, fit: BoxFit.contain)
                        : Image(image: _prescription!.image, fit: BoxFit.cover),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'add_attachment.upload_refund_prescription'.tr(
                            namedArgs: {'type': widget.refundTypeName ?? ''},
                          ),
                          style: AppTextStyles.font12BlueRegular(context),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'add_attachment.prescription_instructions'.tr(),
                          style: AppTextStyles.font8GreyRegular(context),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    _prescription != null
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: _prescription != null
                        ? AppColors.successClr
                        : AppColors.greyClr,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              height: 44.h,
              child: AppButton(
                text: 'Upload',
                onPressed: () {
                  if (_eInvoice != null && _prescription != null) {
                    setState(() {
                      _showAttachmentOptions = false;
                    });
                  }
                },
                isEnabled: _eInvoice != null && _prescription != null,
              ),
            ),
          ],

          // No separate list; previews shown inline above per UX
        ],
      ),
    );
  }
}
