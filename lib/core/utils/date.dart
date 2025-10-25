import 'package:intl/intl.dart';

/// Date formatting utilities
class DateFormatter {
  DateFormatter._();

  static final _dateFormat = DateFormat('MMM dd, yyyy');
  static final _dateFormatKo = DateFormat('yyyy년 M월 d일');
  static final _timeFormat = DateFormat('h:mm a');
  static final _timeFormatKo = DateFormat('a h:mm');
  static final _dateTimeFormat = DateFormat('MMM dd, h:mm a');
  static final _dateTimeFormatKo = DateFormat('M월 d일 a h:mm');

  /// Format date (e.g., "Dec 15, 2023")
  static String formatDate(DateTime date, {String locale = 'en_US'}) {
    if (locale.startsWith('ko')) {
      return _dateFormatKo.format(date);
    }
    return _dateFormat.format(date);
  }

  /// Format time (e.g., "3:45 PM")
  static String formatTime(DateTime date, {String locale = 'en_US'}) {
    if (locale.startsWith('ko')) {
      return _timeFormatKo.format(date);
    }
    return _timeFormat.format(date);
  }

  /// Format date and time (e.g., "Dec 15, 3:45 PM")
  static String formatDateTime(DateTime date, {String locale = 'en_US'}) {
    if (locale.startsWith('ko')) {
      return _dateTimeFormatKo.format(date);
    }
    return _dateTimeFormat.format(date);
  }

  /// Format relative time (e.g., "2 hours ago", "just now")
  static String formatRelative(DateTime date, {String locale = 'en_US'}) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return locale.startsWith('ko') ? '방금' : 'just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return locale.startsWith('ko')
          ? '$minutes분 전'
          : '$minutes minute${minutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return locale.startsWith('ko')
          ? '$hours시간 전'
          : '$hours hour${hours == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return locale.startsWith('ko')
          ? '$days일 전'
          : '$days day${days == 1 ? '' : 's'} ago';
    } else {
      return formatDate(date, locale: locale);
    }
  }

  /// Format date for grouping (e.g., "Today", "Yesterday", "Dec 15")
  static String formatGroupDate(DateTime date, {String locale = 'en_US'}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return locale.startsWith('ko') ? '오늘' : 'Today';
    } else if (dateOnly == yesterday) {
      return locale.startsWith('ko') ? '어제' : 'Yesterday';
    } else {
      return formatDate(date, locale: locale);
    }
  }

  /// Format ETA (Estimated Time of Arrival)
  static String formatETA(DateTime? eta, {String locale = 'en_US'}) {
    if (eta == null) return '';

    final now = DateTime.now();
    final difference = eta.difference(now);

    if (difference.isNegative) {
      return locale.startsWith('ko') ? '목표 기한 초과' : 'Past deadline';
    }

    if (difference.inDays < 1) {
      return locale.startsWith('ko')
          ? 'ETA 오늘'
          : 'ETA Today';
    } else if (difference.inDays < 7) {
      return locale.startsWith('ko')
          ? 'ETA ${difference.inDays}일 후'
          : 'ETA ${difference.inDays} days';
    } else {
      return locale.startsWith('ko')
          ? 'ETA ${formatDate(eta, locale: locale)}'
          : 'ETA ${formatDate(eta, locale: locale)}';
    }
  }
}
