import 'package:intl/intl.dart';

double safeConvertToDouble(String input) {

  input = input.replaceAll(',', '.');
  List<String> parts = input.split('.');
  if (parts.length >= 3) {
    input = '${parts[0]}.${parts[1]}';
  }

  try {
    return double.parse(input);
  } catch (e) {
    return 0.0;
  }
}

String formatDateWithoutTime(DateTime dateTime) {
  final formatter = DateFormat('dd.MM.yyyy');
  return formatter.format(dateTime);
}