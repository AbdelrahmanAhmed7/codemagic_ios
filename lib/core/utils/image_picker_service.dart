import 'package:image_picker/image_picker.dart';
import 'package:mediconsult/features/approval_request/presentation/widgets/attachments/permissions.dart';

class ImagePickerService {
  const ImagePickerService._();

  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> pickFromCameraWithPermission() async {
    final ok = await AttachmentsPermissions.ensureCamera();
    if (!ok) return null;
    return _picker.pickImage(source: ImageSource.camera, maxWidth: 1600);
  }

  static Future<XFile?> pickFromGallery() async {
    return _picker.pickImage(source: ImageSource.gallery, maxWidth: 1600);
  }
}


