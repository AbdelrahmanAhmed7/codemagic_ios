import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  Future<bool> launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> launchEmail(
    String email, {
    String? subject,
    String? body,
  }) async {
    try {
      final uri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          if (subject != null) 'subject': subject,
          if (body != null) 'body': body,
        },
      );
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  Future<bool> launchWhatsApp(String phone, {String? message}) async {
    try {
      final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
      final uri = Uri.parse(
        'https://wa.me/$cleanPhone${message != null ? '?text=${Uri.encodeComponent(message)}' : ''}',
      );
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  Future<bool> makePhoneCall(String phone) async {
    try {
      final uri = Uri(scheme: 'tel', path: phone);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> launchSMS(String phone, {String? message}) async {
    try {
      final uri = Uri(
        scheme: 'sms',
        path: phone,
        queryParameters: message != null ? {'body': message} : null,
      );
      return await launchUrl(uri);
    } catch (_) {
      return false;
    }
  }

  Future<bool> launchFacebook(String url) async {
    try {
      final mobileUrl = url.replaceAll('www.facebook.com', 'm.facebook.com');
      final uri = Uri.parse(mobileUrl);

      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}
