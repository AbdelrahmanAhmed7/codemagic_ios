import 'package:permission_handler/permission_handler.dart';

class AttachmentsPermissions {
  static Future<bool> ensureCamera() async {
    final status = await Permission.camera.status;
    if (status.isGranted) return true;
    final req = await Permission.camera.request();
    return req.isGranted;
  }
}






















