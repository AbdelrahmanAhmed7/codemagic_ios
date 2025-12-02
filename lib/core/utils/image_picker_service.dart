import 'package:image_picker/image_picker.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/attachments/permissions.dart';

class ImagePickerService {
  const ImagePickerService._();

  static final ImagePicker _picker = ImagePicker();

  // Compression settings for better performance
  static const double _maxWidth = 1600.0;
  static const double _maxHeight = 1600.0;
  static const int _imageQuality = 85; // Good balance between quality and size

  /// Pick image from camera with compression and permission check
  static Future<XFile?> pickFromCameraWithPermission({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    final ok = await AttachmentsPermissions.ensureCamera();
    if (!ok) return null;
    return _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: maxWidth ?? _maxWidth,
      maxHeight: maxHeight ?? _maxHeight,
      imageQuality: imageQuality ?? _imageQuality,
    );
  }

  /// Pick image from gallery with compression
  static Future<XFile?> pickFromGallery({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    final ok = await AttachmentsPermissions.ensurePhotos();
    if (!ok) return null;
    return _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: maxWidth ?? _maxWidth,
      maxHeight: maxHeight ?? _maxHeight,
      imageQuality: imageQuality ?? _imageQuality,
    );
  }

  /// Pick multiple images from gallery (if needed in future)
  static Future<List<XFile>> pickMultipleFromGallery({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    return _picker.pickMultiImage(
      maxWidth: maxWidth ?? _maxWidth,
      maxHeight: maxHeight ?? _maxHeight,
      imageQuality: imageQuality ?? _imageQuality,
    );
  }
}
