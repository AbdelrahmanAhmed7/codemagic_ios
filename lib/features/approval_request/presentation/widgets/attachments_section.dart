import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:image_picker/image_picker.dart';
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
    final selection = await showModalBottomSheet<_UploadSelection>(
      context: context,
      backgroundColor: Colors.transparent,
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
                        child: UploadOption(
                          assetIcon: AppAssets.camera,
                          label: 'add_attachment.take_photo'.tr(),
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
                              // Auto-upload: close modal immediately with selection
                              String path = picked.path;
                              Navigator.of(context).pop(
                                _UploadSelection(
                                  image: FileImage(File(path)),
                                  name: picked.name,
                                  path: path,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: UploadOption(
                          assetIcon: AppAssets.upload,
                          label: 'add_attachment.upload_file'.tr(),
                          onTap: () async {
                            final picker = ImagePicker();
                            final picked = await picker.pickImage(
                              source: ImageSource.gallery,
                              maxWidth: 1600,
                            );
                            if (picked != null) {
                              // Auto-upload: close modal immediately with selection
                              String path = picked.path;
                              Navigator.of(context).pop(
                                _UploadSelection(
                                  image: FileImage(File(path)),
                                  name: picked.name,
                                  path: path,
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

    // إزالة focus بعد إغلاق الـ modal (مع delay)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
      // إزالة focus من أي TextField موجود
      FocusManager.instance.primaryFocus?.unfocus();
      // إخفاء الكيبورد بقوة
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    });

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
