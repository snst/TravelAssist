import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/transaction.dart';
import 'package:travel_assist/transaction_value.dart';
import 'currency.dart';
import 'storage.dart';

class CurrencyProvider extends ChangeNotifier with Storage {
  CurrencyProvider() {
    db = openDB();
    init();
  }

  final HashMap<String, Currency> _currencyMap = HashMap();
  List<Currency> get items => _currencyMap.values.toList();
  Currency? _homeCurrency;

  void init() async {
    final isar = await db;
    isar!.txn(() async {
      final currencyList = await isar.currencys.where().findAll();
      for (final currency in currencyList) {
        _currencyMap[currency.name] = currency;
      }
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
      _currencyMap.removeWhere((key, value) => value == item);
      _currencyMap[item.name] = item;
      notifyListeners();
    });
  }

  void delete(Currency item) async {
    final isar = await db;
    await isar!.writeTxn(() async {
      await isar.currencys.delete(item.id);
      _currencyMap.removeWhere((key, value) => value == item);
      notifyListeners();
    });
  }

  Currency? getHomeCurrency() {
    _homeCurrency ??= getCurrencyByName('€');
    return _homeCurrency;
  }

  Currency? getCurrencyByName(String name) {
    return _currencyMap.containsKey(name) ? _currencyMap[name] : null;
  }

  Currency getCurrencyById(int id) {
    return items
        .firstWhere((element) => element.id == id); //, orElse: () => Null);
  }

  TransactionValue getTransactionValue(Transaction transaction) {
    var currency = getCurrencyByName(transaction.currency);
    return TransactionValue(transaction.value, currency);
  }

  TransactionValue convertTo(Transaction transaction, Currency? to) {
    return getTransactionValue(transaction).convertTo(to);
  }

  Currency? getCurrencyFromTransaction(Transaction transaction) {
    return getCurrencyByName(transaction.currency);
  }
}
