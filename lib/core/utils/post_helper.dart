
import 'package:path_provider/path_provider.dart';
import 'dart:io';

String formatPostTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'الآن';
  } else if (difference.inMinutes < 60) {
    return 'منذ ${difference.inMinutes} دقيقة';
  } else if (difference.inHours < 24) {
    return 'منذ ${difference.inHours} ساعة';
  } else if (difference.inDays < 7) {
    return 'منذ ${difference.inDays} يوم';
  } else if (difference.inDays < 30) {
    int weeks = (difference.inDays / 7).floor();
    return 'منذ ${weeks} أسبوع';
  } else if (difference.inDays < 365) {
    int months = (difference.inDays / 30).floor();
    return 'منذ ${months} شهر';
  } else {
    // التاريخ الكامل
    return '${dateTime.day} ${_getArabicMonth(dateTime.month)} ${dateTime.year}';
  }
}

String _getArabicMonth(int month) {
  const months = [
    '', // index 0 is unused
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر'
  ];
  return months[month];
}

