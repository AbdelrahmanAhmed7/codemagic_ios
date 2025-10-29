import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mediconsult/core/utils/app_button.dart';
import 'attachments/attachment_item.dart';
import 'attachments/upload_option.dart';
import 'attachments/permissions.dart';

class AttachmentsSection extends StatefulWidget {
  const AttachmentsSection({
    super.key,
    this.deleteIllustrationAsset,
    this.onAttachmentsChanged,
  });

  final String? deleteIllustrationAsset;
  final Function(List<String>)? onAttachmentsChanged;

  @override
  State<AttachmentsSection> createState() => _AttachmentsSectionState();
}

class _AttachmentsSectionState extends State<AttachmentsSection> {
  final List<AttachmentItem> _items = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _openUploadSheet,
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: const BoxDecoration(
                  color: AppColors.primaryClr,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
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
                        text: 'approval_request.add_attachments'.tr(),
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
        SizedBox(height: 8.h),
        if (_items.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: AppColors.whiteClr,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.greyClr.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: AppColors.lightGreyClr),
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  leading: Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: AppColors.lightGreyClr,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image(image: item.image, fit: BoxFit.cover),
                  ),
                  title: Text(
                    item.name,
                    style: AppTextStyles.font14BlackMedium(context),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.errorClr,
                    ),
                    onPressed: () => _confirmDelete(index),
                  ),
                );
              },
            ),
          ),
        SizedBox(height: 8.h),
        // Upload area removed; plus icon above opens the sheet
      ],
    );
  }

  void _openUploadSheet() async {
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
                                ? UploadOption(
                                    assetIcon: AppAssets.camera,
                                    label: 'Take Photo',
                                    onTap: () async {
                                      final ok =
                                          await AttachmentsPermissions.ensureCamera();
                                      if (!ok) return;
                                      final picker = ImagePicker();
                                      final picked = await picker.pickImage(
                                        source: ImageSource.camera,
                                        maxWidth: 1600,
                                      );
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
                                ? UploadOption(
                                    assetIcon: AppAssets.upload,
                                    label: 'Upload File',
                                    onTap: () async {
                                      final picker = ImagePicker();
                                      final picked = await picker.pickImage(
                                        source: ImageSource.gallery,
                                        maxWidth: 1600,
                                      );
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
                              // Try to extract the file path from FileImage
                              String path = '';
                              final imageProvider = img;
                              if (imageProvider is FileImage) {
                                path = imageProvider.file.path;
                              }
                              Navigator.of(context).pop(
                                _UploadSelection(
                                  image: img,
                                  name: name,
                                  path: path,
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
      _items.add(
        AttachmentItem(
          image: selection.image,
          name: selection.name,
          path: selection.path,
        ),
      );
    });
    _notifyParent();
  }

  void _notifyParent() {
    final filePaths = _items
        .map((item) => item.path)
        .where((p) => p.isNotEmpty)
        .toList();
    widget.onAttachmentsChanged?.call(filePaths);
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
      setState(() => _items.removeAt(index));
      _notifyParent();
    }
  }
}

class _UploadSelection {
  _UploadSelection({
    required this.image,
    required this.name,
    required this.path,
  });
  final ImageProvider image;
  final String name;
  final String path;
}
