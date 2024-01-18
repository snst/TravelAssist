import 'package:hive/hive.dart';
part 'currency.g.dart';

// flutter packages pub run build_runner build

@HiveType(typeId: 4)
class Currency extends HiveObject {
  Currency({this.name = "", this.value = 1.0});

  @HiveField(0)
  String name;
  @HiveField(1)
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

  static String formatValue(double value) => value.toStringAsFixed(2);
}
