import 'package:isar/isar.dart';
part 'currency.g.dart';

// flutter packages pub run build_runner build
// flutter pub run build_runner build

@collection
class Currency {
  Currency({this.name = "", this.value = 1.0});

  Id id = Isar.autoIncrement;
  String name;
  double value;

  double convertTo(double value, Currency? to) {
    return to != null && this != to ? Currency.convert(value, this, to) : value;
  }

  static double convert(double value, Currency? from, Currency? to) {
    if (from == null || to == null) {
      return value;
    } else {
      return value / from.value * to.value;
    }
  }

  String convertToString(double value, Currency? to) {
    return Currency.formatValue(Currency.convert(value, this, to));
  }

  @override
  String toString() => name;

  static String formatValue(double value) => value.toStringAsFixed(2);

  static String formatValueCurrency(double value, String currency) => "${Currency.formatValue(value)} $currency";

}
