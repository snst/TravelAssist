
import 'package:hive/hive.dart';
part 'currency.g.dart';

// flutter packages pub run build_runner build

@HiveType(typeId: 4)
class Currency {
  Currency(
      {this.name = "",
      this.value = 1.0});

  @HiveField(0)
  String name;
  @HiveField(1)
  double value;
}

@HiveType(typeId: 5)
class CurrencyList {
  @HiveField(0)
  List<Currency> items = [];

  bool addCurrency(String name, double value) {
    bool existing = items.any((currency) => currency.name == name);
    if (!existing) {
      items.add(Currency(name:name, value:value));
    }
    return !existing;
  }
}