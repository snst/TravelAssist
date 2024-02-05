import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
part 'currency.g.dart';

@collection
@JsonSerializable()
class Currency {
  Currency({this.name = "", this.value = 1.0});

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  static String formatValueCurrency(double value, String currency) =>
      "${Currency.formatValue(value)} $currency";

  factory Currency.fromJson(Map<String, dynamic> json) =>
      _$CurrencyFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyToJson(this);
}
