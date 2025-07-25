import 'package:intl/intl.dart';
import 'package:social_media_app/features/user_tracking/LogEntry.dart';

String formatPostTime(DateTime dateTime, {DateTime? now}) {
  final localDateTime = dateTime.toLocal();
  final current = now ?? DateTime.now();
  final difference = current.difference(localDateTime);

  if (difference.inSeconds < 10) {
    return 'just now';
  } else if (difference.inSeconds < 60) {
    return '${difference.inSeconds} seconds ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
  } else if (difference.inDays < 30) {
    int weeks = (difference.inDays / 7).floor();
    return '${weeks} week${weeks == 1 ? '' : 's'} ago';
  } else if (difference.inDays < 365) {
    int months = (difference.inDays / 30).floor();
    return '${months} month${months == 1 ? '' : 's'} ago';
  } else {
    return '${_getEnglishMonth(localDateTime.month)} ${localDateTime.day}, ${localDateTime.year}';
  }
}

String _getEnglishMonth(int month) {
  const months = [
    '', // index 0 is unused
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  return months[month];
}

String formatchatDate(String utcDate) {
  final dateTime = DateTime.parse(utcDate).toLocal();
  final now = DateTime.now();

  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final inputDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

  if (inputDate == today) {
    return DateFormat('hh:mm a', 'en_US').format(dateTime);
  } else if (inputDate == yesterday) {
    return 'Yesterday';
  } else {
    return DateFormat('MMM dd, yyyy', 'en_US').format(dateTime);
  }
}
Map<String, dynamic> toJsonLogs(Map<String, List<LogEntry>> logs) {
  return {
    "logs": logs.map((category, entries) {
      return MapEntry(
        category,
        entries.map((e) => [e.action, e.timestamp.toIso8601String()]).toList(),
      );
    }),
  };
}
