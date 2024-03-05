import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/currency_provider.dart';
import 'package:travel_assist/transaction_value.dart';
import 'storage.dart';
import 'transaction.dart';

class TransactionProvider extends ChangeNotifier with Storage {
  final Map<String, TransactionValue> expensePerCurrency = HashMap();
  final Map<String, TransactionValue> withdrawPerCurrency = HashMap();
  final Map<String, TransactionValue> balancePerCurrency = HashMap();
  TransactionValue? allExpenses;
  TransactionValue? allWithdraws;
  TransactionValue? allBalance;
  bool useDb;

  TransactionProvider({this.useDb = true}) {
    if (useDb) {
      db = openDB();
      init();
    }
  }

  List<Transaction> _items = [];
  List<Transaction> get items => _items;

  void init() async {
    final isar = await db;
    isar!.txn(() async {
      _items = await isar.transactions.where().findAll();
      notifyListeners();
    });
  }

  static TransactionProvider getInstance(BuildContext context) {
    return Provider.of<TransactionProvider>(context, listen: false);
  }

  void add(Transaction item) async {
    addList([item]);
  }

  void addList(List<Transaction> items) async {
    if (useDb) {
      final isar = await db;
      await isar!.writeTxn(() async {
        for (final item in items) {
          await isar.transactions.put(item);
          if (!_items.contains(item)) {
            _items.add(item);
          }
        }
        notifyListeners();
      });
    } else {
      for (final item in items) {
        if (!_items.contains(item)) {
          _items.add(item);
        }
      }
      notifyListeners();
    }
  }

  void delete(Transaction item) async {
    if (useDb) {
      final isar = await db;
      await isar!.writeTxn(() async {
        await isar.transactions.delete(item.id);
        _items.remove(item);
        notifyListeners();
      });
    } else {
      _items.remove(item);
      notifyListeners();
    }
  }

  void clear() async {
    if (useDb) {
      final isar = await db;
      await isar!.writeTxn(() async {
        await isar.transactions.clear();
        _items.clear();
        notifyListeners();
      });
    } else {
      _items.clear();
      notifyListeners();
    }
  }

  List<Transaction> getSortedTransactions(DateTime? until) {
    List<Transaction> ret = items;
    if (until != null) {
      ret = items.where((element) => !element.date.isAfter(until)).toList();
    }

    ret.sort(transactionComparison);
    return ret;
  }

  int transactionComparison(Transaction a, Transaction b) {
    var ret = a.date.compareTo(b.date);
    return ret;
  }

  void caluculateAll(CurrencyProvider currencyProvider) {
    allExpenses = TransactionValue(0, currencyProvider.getHomeCurrency());
    allWithdraws = TransactionValue(0, currencyProvider.getHomeCurrency());
    allBalance = TransactionValue(0, currencyProvider.getHomeCurrency());

    for (final currency in currencyProvider.visibleItems) {
      expensePerCurrency[currency.name] = TransactionValue(0, currency);
      withdrawPerCurrency[currency.name] = TransactionValue(0, currency);
      balancePerCurrency[currency.name] = TransactionValue(0, currency);
    }

    for (final transaction in items) {
      final tv = currencyProvider.getTransactionValue(transaction);
      if (transaction.isWithdrawal) {
        allWithdraws?.add(tv);
        allBalance?.add(tv);
        withdrawPerCurrency[transaction.currency]?.add(tv);
        balancePerCurrency[transaction.currency]?.add(tv);
      } else {
        allExpenses?.add(tv);
        allBalance?.sub(tv);
        expensePerCurrency[transaction.currency]?.add(tv);
        balancePerCurrency[transaction.currency]?.sub(tv);
      }
    }
  }

  String toJson() {
    List<Map<String, dynamic>> jsonList =
        _items.map((item) => item.toJson()).toList();
    return jsonEncode(jsonList);
  }

  void fromJson(String? jsonString) {
    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);
      List<Transaction> newItems =
          jsonList.map((json) => Transaction.fromJson(json)).toList();
      clear();
      addList(newItems);
    }
  }
}
