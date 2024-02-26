import 'package:intl/intl.dart';

class Formatter {
  static String dateToString(DateTime? date) =>
      date != null ? DateFormat('EEEE, d MMMM y').format(date) : "";
}
