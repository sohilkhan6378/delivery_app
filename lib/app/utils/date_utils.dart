import 'package:intl/intl.dart';

class AppDateUtils {
  static String isoNow() {
    return DateTime.now().toIso8601String();
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }
}
