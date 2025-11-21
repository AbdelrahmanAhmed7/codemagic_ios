import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationDateFormatter {
  static String tr(BuildContext context, String key, String fallback) {
    final translated = key.tr();
    return translated == key ? fallback : translated;
  }

  static String formatDateHeader(BuildContext context, String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        int day, month, year;
        
        if (parts[0].length == 4) {
          // YYYY-MM-DD
          year = int.parse(parts[0]);
          month = int.parse(parts[1]);
          day = int.parse(parts[2]);
        } else {
          // DD-MM-YYYY
          day = int.parse(parts[0]);
          month = int.parse(parts[1]);
          year = int.parse(parts[2]);
        }
        
        final date = DateTime(year, month, day);
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final yesterday = today.subtract(const Duration(days: 1));
        
        if (date == today) {
          return tr(context, 'notifications.today', 'Today');
        } else if (date == yesterday) {
          return tr(context, 'notifications.yesterday', 'Yesterday');
        } else {
          return _formatFullDate(context, date);
        }
      }
    } catch (e) {
      // Fallback to original date string
    }
    return dateStr;
  }

  static String _formatFullDate(BuildContext context, DateTime date) {
    final weekdays = [
      tr(context, 'notifications.days.monday', 'Monday'),
      tr(context, 'notifications.days.tuesday', 'Tuesday'),
      tr(context, 'notifications.days.wednesday', 'Wednesday'),
      tr(context, 'notifications.days.thursday', 'Thursday'),
      tr(context, 'notifications.days.friday', 'Friday'),
      tr(context, 'notifications.days.saturday', 'Saturday'),
      tr(context, 'notifications.days.sunday', 'Sunday'),
    ];
    
    final months = [
      tr(context, 'notifications.months.jan', 'Jan'),
      tr(context, 'notifications.months.feb', 'Feb'),
      tr(context, 'notifications.months.mar', 'Mar'),
      tr(context, 'notifications.months.apr', 'Apr'),
      tr(context, 'notifications.months.may', 'May'),
      tr(context, 'notifications.months.jun', 'Jun'),
      tr(context, 'notifications.months.jul', 'Jul'),
      tr(context, 'notifications.months.aug', 'Aug'),
      tr(context, 'notifications.months.sep', 'Sep'),
      tr(context, 'notifications.months.oct', 'Oct'),
      tr(context, 'notifications.months.nov', 'Nov'),
      tr(context, 'notifications.months.dec', 'Dec'),
    ];
    
    final weekday = weekdays[date.weekday - 1];
    final monthName = months[date.month - 1];
    return '$weekday, ${date.day} $monthName ${date.year}';
  }
}
