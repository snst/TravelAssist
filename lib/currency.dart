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

  double convertTo(double value, Currency to) {
    return Currency.convert(value, this, to);
  }

  static double convert(double value, Currency from, Currency to) {
    double ret = value / from.value * to.value;
    return ret;
  }

  String convertToString(double value, Currency to) {
    return Currency.formatValue(Currency.convert(value, this, to));
  }

  @override
  String toString() => name;

  static String formatValue(double value) => value.toStringAsFixed(2);
}
