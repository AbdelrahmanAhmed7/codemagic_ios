import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediconsult/core/constants/app_assets.dart';
import 'package:mediconsult/core/theming/app_colors.dart';
import 'package:mediconsult/core/theming/app_text_styles.dart';
import 'package:mediconsult/core/utils/app_button.dart';
import 'package:mediconsult/features/shared/upload/upload_picker_sheet.dart' as shared_sheet;
import 'package:mediconsult/features/chronic_medicines/widgets/row_upload_tile.dart';

class LabResultsUpload extends StatefulWidget {
  const LabResultsUpload({super.key});

  @override
  State<LabResultsUpload> createState() => LabResultsUploadState();
}

class LabResultsUploadState extends State<LabResultsUpload> {
  ImageProvider? _bloodSugarImage;
  ImageProvider? _kidneyImage;
  VoidCallback? _rebuildDialog;

  bool get isComplete => _bloodSugarImage != null && _kidneyImage != null;


  Future<void> _showPickOptions({required bool forBlood}) async {
    final result = await shared_sheet.showUploadPickerSheet(context);

    if (!mounted) return;
    if (result == null) return;
    setState(() {
      if (forBlood) {
        _bloodSugarImage = result.image;
      } else {
        _kidneyImage = result.image;
      }
    });
    _rebuildDialog?.call();
  }

  void _showUploadDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.4),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            _rebuildDialog = () => setDialogState(() {});
            return Center(
              child: Container(
                width: 300.w,
                height: 600.h,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Image.asset(AppAssets.labDoctor, width: 144.w, height: 144.h),
                    SizedBox(height: 12.h),
                    Text(
                      "Lab Test Due",
                      style: AppTextStyles.font14BlueMedium(context).copyWith(decoration: TextDecoration.none),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "It’s time for your quarterly lab tests",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.font12GreyRegular(context).copyWith(decoration: TextDecoration.none),
                    ),
                    SizedBox(height: 20.h),

                    // Blood sugar test
                    _RowUploadTile(
                      title: 'Blood Sugar Test Report',
                      description: 'Should be included name and date',
                      image: _bloodSugarImage,
                      onTap: () async { await _showPickOptions(forBlood: true); },
                      onRemove: () {
                        setState(() => _bloodSugarImage = null);
                        _rebuildDialog?.call();
                      },
                      isDone: _bloodSugarImage != null,
                      showConnectorBelow: true,
                      connectorGreen: (_bloodSugarImage != null && _kidneyImage != null),
                    ),
                    SizedBox(height: 12.h),

                    // Kidney test
                    _RowUploadTile(
                      title: 'Kidney Function Test Report',
                      description: 'Should be included name and date',
                      image: _kidneyImage,
                      onTap: () async { await _showPickOptions(forBlood: false); },
                      onRemove: () {
                        setState(() => _kidneyImage = null);
                        _rebuildDialog?.call();
                      },
                      isDone: _kidneyImage != null,
                      showConnectorBelow: false,
                      connectorGreen: (_bloodSugarImage != null && _kidneyImage != null),
                    ),

                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: AppButton(
                        text: 'Upload Lab Results',
                        isEnabled: isComplete,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tap area to open dialog
        GestureDetector(
          onTap: _showUploadDialog,
          child: Container(
            width: double.infinity,
            height: 120.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppAssets.uploadLabResults, width: 40.w, height: 40.h),
                SizedBox(height: 8.h),
                Text(
                  'Tap to upload your lab\n test results',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font10GreyRegular(context),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        // External previews mirroring dialog state
        if (_bloodSugarImage != null)
          RowUploadTile(
            title: 'Blood Sugar Test',
            description: 'Should be included name and date',
            image: _bloodSugarImage,
            borderColor: const Color(0xFF3B82F6),
            onTap: () async { await _showPickOptions(forBlood: true); },
            onRemove: () { setState(() => _bloodSugarImage = null); },
          ),
        if (_bloodSugarImage != null && _kidneyImage != null) SizedBox(height: 10.h),
        if (_kidneyImage != null)
          RowUploadTile(
            title: 'Kidney Function Test',
            description: 'Should be included name and date',
            image: _kidneyImage,
            borderColor: const Color(0xFF3B82F6),
            onTap: () async { await _showPickOptions(forBlood: false); },
            onRemove: () { setState(() => _kidneyImage = null); },
          ),
      ],
    );
  }
}

class _RowUploadTile extends StatelessWidget {
  const _RowUploadTile({
    required this.title,
    required this.description,
    required this.onTap,
    required this.onRemove,
    required this.isDone,
    this.image,
    this.showConnectorBelow = false,
    this.connectorGreen = false,
  });

  final String title;
  final String description;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final bool isDone;
  final ImageProvider? image;
  final bool showConnectorBelow;
  final bool connectorGreen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.whiteClr,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xffECECEC)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left status column with circle and optional connector
            Column(
              children: [
                Icon(
                  isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isDone ? AppColors.successClr : AppColors.greyClr,
                ),
                if (showConnectorBelow)
                  Container(
                    width: 2,
                    height: 40.h,
                    color: connectorGreen ? AppColors.successClr : (isDone ? AppColors.successClr : AppColors.greyClr),
                  ),
              ],
            ),
            SizedBox(width: 10.w),
            Container(
              width: 50.w,
              height: 45.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.lightGreyClr,
              ),
              clipBehavior: Clip.antiAlias,
              child: image == null
                  ? Image.asset(AppAssets.uploadIcon, fit: BoxFit.contain)
                  : Image(image: image!, fit: BoxFit.cover),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.font12BlueRegular(context).copyWith(decoration: TextDecoration.none)),
                  SizedBox(height: 4.h),
                  Text(description, style: AppTextStyles.font8GreyRegular(context).copyWith(decoration: TextDecoration.none)),
                ],
              ),
            ),
            if (image != null)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: onRemove,
                tooltip: 'Remove',
              ),
          ],
        ),
      ),
    );
  }
}