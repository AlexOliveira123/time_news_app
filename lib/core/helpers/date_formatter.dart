import 'package:intl/intl.dart';

abstract class DateFormatter {
  static String format(String isoDate, {String pattern = 'dd-MM-yyyy'}) {
    final date = DateTime.parse(isoDate);
    return DateFormat(pattern).format(date);
  }
}
