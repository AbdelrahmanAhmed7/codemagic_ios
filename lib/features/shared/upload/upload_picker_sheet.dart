import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/utils/app_button.dart';
import 'package:mediconsult/core/utils/image_picker_service.dart';

class UploadSelection {
  UploadSelection({required this.image, required this.name});
  final ImageProvider image;
  final String name;
}

Future<UploadSelection?> showUploadPickerSheet(BuildContext context) async {
  ImageProvider? previewCameraImage;
  String? previewCameraName;
  ImageProvider? previewGalleryImage;
  String? previewGalleryName;

  return showModalBottomSheet<UploadSelection>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
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
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: (previewCameraImage == null)
                              ? _UploadOption(
                                  assetIcon: AppAssets.camera,
                                  label: 'Take Photo',
                                  onTap: () async {
                                    final picked = await ImagePickerService.pickFromCameraWithPermission();
                                    if (picked != null) {
                                      setModalState(() {
                                        previewCameraImage = FileImage(File(picked.path));
                                        previewCameraName = picked.name;
                                      });
                                    }
                                  },
                                )
                              : _PreviewThumb(image: previewCameraImage!, name: previewCameraName ?? 'selected'),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: (previewGalleryImage == null)
                              ? _UploadOption(
                                  assetIcon: AppAssets.upload,
                                  label: 'Upload File',
                                  onTap: () async {
                                    final picked = await ImagePickerService.pickFromGallery();
                                    if (picked != null) {
                                      setModalState(() {
                                        previewGalleryImage = FileImage(File(picked.path));
                                        previewGalleryName = picked.name;
                                      });
                                    }
                                  },
                                )
                              : _PreviewThumb(image: previewGalleryImage!, name: previewGalleryName ?? 'selected'),
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
                          final img = previewCameraImage ?? previewGalleryImage;
                          final name = previewCameraName ?? previewGalleryName;
                          if (img != null && name != null) {
                            Navigator.of(context).pop(UploadSelection(image: img, name: name));
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
}

class _UploadOption extends StatelessWidget {
  const _UploadOption({required this.assetIcon, required this.label, required this.onTap});
  final String assetIcon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(assetIcon, width: 48.w, height: 48.w, fit: BoxFit.contain),
            SizedBox(height: 8.h),
            Text(label, style: AppTextStyles.font14BlackMedium(context)),
          ],
        ),
      ),
    );
  }
}

class _PreviewThumb extends StatelessWidget {
  const _PreviewThumb({required this.image, required this.name});
  final ImageProvider image;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12.r),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image(image: image, fit: BoxFit.cover),
        ),
        SizedBox(height: 8.h),
        Text(name, style: AppTextStyles.font14BlackMedium(context)),
      ],
    );
  }
}


