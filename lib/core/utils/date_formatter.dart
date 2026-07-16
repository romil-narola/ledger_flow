import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

/// Utility class for formatting and parsing dates
class DateFormatter {
  DateFormatter._();

  static final DateFormat _displayFormat =
      DateFormat(AppConstants.displayDateFormat);
  static final DateFormat _displayDateTimeFormat =
      DateFormat(AppConstants.displayDateTimeFormat);
  static final DateFormat _dbFormat = DateFormat(AppConstants.dbDateFormat);
  static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy');
  static final DateFormat _shortMonthFormat = DateFormat('MMM yyyy');
  static final DateFormat _dayMonthFormat = DateFormat('dd MMM');

  /// Format DateTime to display string (e.g., 26/06/2025)
  static String format(DateTime date) {
    return _displayFormat.format(date);
  }

  /// Format DateTime to display string with time
  static String formatWithTime(DateTime date) {
    return _displayDateTimeFormat.format(date);
  }

  /// Format DateTime to database string (e.g., 2025-06-26)
  static String toDb(DateTime date) {
    return _dbFormat.format(date);
  }

  /// Format DateTime to month year string (e.g., June 2025)
  static String toMonthYear(DateTime date) {
    return _monthYearFormat.format(date);
  }

  /// Format DateTime to short month string (e.g., Jun 2025)
  static String toShortMonth(DateTime date) {
    return _shortMonthFormat.format(date);
  }

  /// Format DateTime to day-month string (e.g., 26 Jun)
  static String toDayMonth(DateTime date) {
    return _dayMonthFormat.format(date);
  }

  /// Parse display format string to DateTime
  static DateTime? parseDisplay(String value) {
    try {
      return _displayFormat.parse(value);
    } catch (_) {
      return null;
    }
  }

  /// Parse database format string to DateTime
  static DateTime? parseDb(String value) {
    try {
      return _dbFormat.parse(value);
    } catch (_) {
      return null;
    }
  }

  /// Get start of day for a given date
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day for a given date
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Get start of month
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get end of month
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Get relative date label
  static String getRelativeLabel(DateTime date) {
    if (isToday(date)) return 'Today';
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    }
    return format(date);
  }
}
