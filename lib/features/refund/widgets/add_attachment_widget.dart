import 'dart:io';
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
  const AddAttachmentWidget({super.key, this.refundTypeName});

  final String? refundTypeName;

  @override
  State<AddAttachmentWidget> createState() => _AddAttachmentWidgetState();
}

class _AddAttachmentWidgetState extends State<AddAttachmentWidget> {
  final List<AttachmentItem> _attachments = [];
  bool _showAttachmentOptions = false;
  AttachmentItem? _eInvoice;
  AttachmentItem? _prescription;

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
                                    'Take Photo',
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
                                        style: AppTextStyles.font14BlackMedium,
                                      ),
                                    ],
                                  ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: (previewGalleryImage == null)
                                ? _buildUploadOption(
                                    AppAssets.upload,
                                    'Upload File',
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
                                        style: AppTextStyles.font14BlackMedium,
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
      final item = AttachmentItem(
        image: selection.imageProvider,
        name: selection.name, path: '',
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
            Text(label, style: AppTextStyles.font14BlackMedium),
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
                          text: 'Add Attachment ',
                          style: AppTextStyles.font14BlackMedium,
                        ),
                        TextSpan(
                          text: '(maximum size 5MB)',
                          style: AppTextStyles.font10GreyRegular,
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
                '${widget.refundTypeName ?? 'Glasses'} Attachment',
                style: AppTextStyles.font14BlackMedium,
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
                          'Upload E-Invoice',
                          style: AppTextStyles.font12BlueRegular,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Should be included name , national ID and Tax activity code',
                          style: AppTextStyles.font8GreyRegular,
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
                          'Upload ${widget.refundTypeName ?? 'Glasses'} Prescription',
                          style: AppTextStyles.font12BlueRegular,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Should be included name and date',
                          style: AppTextStyles.font8GreyRegular,
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

  Widget _buildAttachmentOption(String title, String description, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.greyClr.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
            ),
            if (index == 1)
              Container(
                width: 1.5,
                height: 40.h,
                color: AppColors.greyClr.withValues(alpha: 0.5),
              ),
          ],
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: AppColors.lightGreyClr,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Icon(
                      Icons.insert_drive_file_outlined,
                      color: AppColors.primaryClr,
                      size: 16.w,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(title, style: AppTextStyles.font14BlackMedium),
                ],
              ),
              SizedBox(height: 4.h),
              Padding(
                padding: EdgeInsets.only(left: 32.w),
                child: Text(
                  description,
                  style: AppTextStyles.font10GreyRegular,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
