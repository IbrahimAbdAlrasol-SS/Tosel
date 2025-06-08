String timeAgoArabic(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'قبل ثوانٍ';
  } else if (difference.inMinutes < 60) {
    return 'قبل ${difference.inMinutes} دقيقة${difference.inMinutes == 1 ? '' : difference.inMinutes < 11 ? 's' : ''}';
  } else if (difference.inHours < 24) {
    return 'قبل ${difference.inHours} ساعة';
  } else if (difference.inDays < 30) {
    return 'قبل ${difference.inDays} يوم';
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return 'قبل $months شهر';
  } else {
    final years = (difference.inDays / 365).floor();
    return 'قبل $years سنة';
  }
}
