import 'package:intl/intl.dart';

/// Helper class for formatting dates
class DateFormatter {
  /// Format date string to "27 Nov 2024" format
  /// Accepts various date formats and returns formatted string
  static String formatDate(String dateString) {
    try {
      // Try to parse the date string
      DateTime? date;
      
      // Try common date formats
      final formats = [
        'yyyy-MM-dd',           // 2024-11-27
        'dd/MM/yyyy',           // 27/11/2024
        'MM/dd/yyyy',           // 11/27/2024
        'dd-MM-yyyy',           // 27-11-2024
        'yyyy/MM/dd',           // 2024/11/27
        'dd MMM yyyy',          // 27 Nov 2024
        'MMM dd, yyyy',         // Nov 27, 2024
        'yyyy-MM-dd HH:mm:ss',  // 2024-11-27 10:30:00
      ];
      
      for (final format in formats) {
        try {
          date = DateFormat(format).parse(dateString);
          break;
        } catch (e) {
          continue;
        }
      }
      
      // If no format worked, return original string
      if (date == null) {
        return dateString;
      }
      
      // Format to "27 Nov 2024"
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      // If any error occurs, return original string
      return dateString;
    }
  }
  
  /// Format time string to "10:30 AM" format
  static String formatTime(String timeString) {
    try {
      // Try to parse the time string
      DateTime? time;
      
      // Try common time formats
      final formats = [
        'HH:mm:ss',    // 10:30:00
        'HH:mm',       // 10:30
        'hh:mm a',     // 10:30 AM
        'hh:mm:ss a',  // 10:30:00 AM
      ];
      
      for (final format in formats) {
        try {
          time = DateFormat(format).parse(timeString);
          break;
        } catch (e) {
          continue;
        }
      }
      
      // If no format worked, return original string
      if (time == null) {
        return timeString;
      }
      
      // Format to "10:30 AM"
      return DateFormat('hh:mm a').format(time);
    } catch (e) {
      // If any error occurs, return original string
      return timeString;
    }
  }
  
  /// Format date and time together
  static String formatDateTime(String dateString, String timeString) {
    final formattedDate = formatDate(dateString);
    final formattedTime = formatTime(timeString);
    return '$formattedDate at $formattedTime';
  }
}
