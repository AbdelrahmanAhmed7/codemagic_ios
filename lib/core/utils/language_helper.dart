import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Helper class to get current language code throughout the app
/// 
/// Usage in widgets with context:
/// ```dart
/// LanguageHelper.getLanguageCode(context)
/// ```
/// 
/// Usage in cubits/repositories (pass from widget):
/// ```dart
/// // In widget:
/// context.read<MyCubit>().getData(LanguageHelper.getLanguageCode(context));
/// ```
class LanguageHelper {
  /// Get current language code from context
  /// This is the recommended way to get language code
  static String getLanguageCode(BuildContext context) {
    return context.locale.languageCode;
  }
}
