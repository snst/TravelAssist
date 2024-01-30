import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'currency.dart';
import 'storage.dart';

class CurrencyProvider extends ChangeNotifier with Storage {
  CurrencyProvider() {
    db = openDB();
    init();
  }

  List<Currency> _items = [];
  List<Currency> get items => _items;

  void init() async {
    final isar = await db;
    isar!.txn(() async {
      _items = await isar.currencys.where().findAll();
      notifyListeners();
    });
  }

  static CurrencyProvider getInstance(BuildContext context) {
    return Provider.of<CurrencyProvider>(context, listen: false);
  }

  void add(Currency item) async {
    final isar = await db;
    await isar!.writeTxn(() async {
      await isar.currencys.put(item);
      if (!_items.contains(item)) {
        _items.add(item);
      }
      notifyListeners();
    });
  }

  void delete(Currency item) async {
    final isar = await db;
    await isar!.writeTxn(() async {
      await isar.currencys.delete(item.id);
      _items.remove(item);
      notifyListeners();
    });
  }

  Currency getHomeCurrency() => items.first;

  Currency getCurrencyByName(String name) {
    return items
        .firstWhere((element) => element.name == name); //, orElse: () => Null);
  }

  Currency getCurrencyById(int id) {
    return items
        .firstWhere((element) => element.id == id); //, orElse: () => Null);
  }

}
