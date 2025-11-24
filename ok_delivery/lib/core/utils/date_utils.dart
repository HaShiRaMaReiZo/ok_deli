/// Utility functions for date and time formatting with Myanmar timezone support
class MyanmarDateUtils {
  // Myanmar timezone is UTC+6:30
  static const int myanmarOffsetHours = 6;
  static const int myanmarOffsetMinutes = 30;

  /// Convert UTC DateTime to Myanmar timezone (UTC+6:30)
  /// Ensures the input DateTime is treated as UTC
  static DateTime toMyanmarTime(DateTime utcDateTime) {
    // Ensure we're working with UTC time
    final utc = utcDateTime.isUtc ? utcDateTime : utcDateTime.toUtc();
    // Add Myanmar offset (6:30) to get Myanmar time
    // Create a new DateTime with the adjusted values (not UTC, but local Myanmar time)
    final myanmarTime = utc.add(
      Duration(hours: myanmarOffsetHours, minutes: myanmarOffsetMinutes),
    );
    // Return as local time (not UTC) so .hour, .day etc give Myanmar values
    return DateTime(
      myanmarTime.year,
      myanmarTime.month,
      myanmarTime.day,
      myanmarTime.hour,
      myanmarTime.minute,
      myanmarTime.second,
      myanmarTime.millisecond,
      myanmarTime.microsecond,
    );
  }

  /// Get current Myanmar time
  static DateTime getMyanmarNow() {
    return toMyanmarTime(DateTime.now().toUtc());
  }

  /// Format date for display (Myanmar timezone)
  static String formatDate(DateTime utcDateTime) {
    final myanmarTime = toMyanmarTime(utcDateTime);
    final now = getMyanmarNow();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(
      myanmarTime.year,
      myanmarTime.month,
      myanmarTime.day,
    );

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[myanmarTime.month - 1]} ${myanmarTime.day.toString().padLeft(2, '0')}, ${myanmarTime.year}';
    }
  }

  /// Format date and time for display (Myanmar timezone)
  static String formatDateTime(DateTime utcDateTime) {
    final myanmarTime = toMyanmarTime(utcDateTime);
    return '${myanmarTime.day}/${myanmarTime.month}/${myanmarTime.year} ${myanmarTime.hour.toString().padLeft(2, '0')}:${myanmarTime.minute.toString().padLeft(2, '0')}';
  }

  /// Format date only (Myanmar timezone)
  static String formatDateOnly(DateTime utcDateTime) {
    final myanmarTime = toMyanmarTime(utcDateTime);
    return '${myanmarTime.day}/${myanmarTime.month}/${myanmarTime.year}';
  }

  /// Get date key for grouping (Myanmar timezone)
  static DateTime getDateKey(DateTime utcDateTime) {
    final myanmarTime = toMyanmarTime(utcDateTime);
    return DateTime(myanmarTime.year, myanmarTime.month, myanmarTime.day);
  }
}
