import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'currency.dart';

class SettingsModel extends ChangeNotifier {
  Box<Currency>? _currencyBox;

  void load() async {
    if (_currencyBox == null) {
      _currencyBox = await Hive.openBox('currencyList');
      notifyListeners();
    }
  }

  List<Currency> get currencies =>
      _currencyBox != null ? _currencyBox!.values.toList() : [];

  bool addCurrency(Currency currency) {
    if (_currencyBox!.containsKey(currency.key)) {
      _currencyBox?.put(currency.key, currency);
      notifyListeners();
      return true;
    } else if (currencies.any((element) => element.name == currency.name)) {
      return false;
    } else {
      _currencyBox?.add(currency);
      notifyListeners();
      return true;
    }
  }

  void deleteCurrency(Currency currency) {
    _currencyBox?.delete(currency.key);
    notifyListeners();
  }

  Currency getHomeCurrency() => currencies.first;

  Currency getCurrency(String name) {
    return currencies.firstWhere((element) => element.name == name);//, orElse: () => Null);
  }

}
