import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/payment_method.dart';
//import 'package:travel_assist/transaction.dart';
//import 'package:travel_assist/transaction_value.dart';
//import 'payment_provider.dart';
import 'storage.dart';

class PaymentMethodProvider extends ChangeNotifier with Storage {
  PaymentMethodProvider({this.useDb = true}) {
    if (useDb) {
      db = openDB();
      init();
    }
  }

  bool useDb;
  final chashItem = PaymentMethod(name: "Cash", cash: true);
  final HashMap<String, PaymentMethod> _paymentMethodMap = HashMap();
  List<PaymentMethod> get allItems => [chashItem] + _paymentMethodMap.values.toList();
  List<String> get allItemsAsString => allItems.map((obj) => obj.name).toList();
  PaymentMethod get defaultMethod => chashItem;
  PaymentMethod getDefaultMethod() { return chashItem; }

  void init() async {
    final isar = await db;
    isar!.txn(() async {
      final itemList = await isar.paymentMethods.where().findAll();
      //_paymentMethodMap[chashItem.name] = chashItem;
      for (final item in itemList) {
        _paymentMethodMap[item.name] = item;
      }
      notifyListeners();
    });
  }

  static PaymentMethodProvider getInstance(BuildContext context) {
    return Provider.of<PaymentMethodProvider>(context, listen: false);
  }

  PaymentMethod? getByName(String name) {
    return _paymentMethodMap.containsKey(name) ? _paymentMethodMap[name] : null;
  }

  void add(PaymentMethod item) async {
    if (useDb) {
      final isar = await db;
      await isar!.writeTxn(() async {
        await isar.paymentMethods.put(item);
        _paymentMethodMap.removeWhere((key, value) => value == item);
        _paymentMethodMap[item.name] = item;
        notifyListeners();
      });
    } else {
      _paymentMethodMap.removeWhere((key, value) => value == item);
      _paymentMethodMap[item.name] = item;
      notifyListeners();
    }
  }

  void delete(PaymentMethod item) async {
    if (useDb) {
      final isar = await db;
      await isar!.writeTxn(() async {
        await isar.paymentMethods.delete(item.id);
        _paymentMethodMap.removeWhere((key, value) => value == item);
        notifyListeners();
      });
    } else {
      _paymentMethodMap.removeWhere((key, value) => value == item);
      notifyListeners();
    }
  }
}
