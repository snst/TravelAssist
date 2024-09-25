import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/balance.dart';
import 'package:travel_assist/currency.dart';
import 'package:travel_assist/currency_provider.dart';
import 'package:travel_assist/transaction_value.dart';
import 'storage.dart';
import 'transaction.dart';

class TransactionProvider extends ChangeNotifier with Storage {
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

  List<String> getCategoryList() {
    Map<String, int> occurrenceMap = {};
    for (final transaction in items) {
      final str = transaction.category;
      occurrenceMap[str] = (occurrenceMap[str] ?? 0) + 1;
    }
    List<String> sortedUniqueStrings = occurrenceMap.keys.toList()
      ..sort((a, b) => occurrenceMap[b]!.compareTo(occurrenceMap[a]!));

    return sortedUniqueStrings;
  }

    List<String> getPaymentMethodList() {
    Map<String, int> occurrenceMap = {};
    for (final transaction in items) {
      final str = transaction.method;
      occurrenceMap[str] = (occurrenceMap[str] ?? 0) + 1;
    }
    List<String> sortedUniqueStrings = occurrenceMap.keys.toList()
      ..sort((a, b) => occurrenceMap[b]!.compareTo(occurrenceMap[a]!));

    return sortedUniqueStrings;
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

  List<String> getUsedPaymentMethods() {
    List<String> methods = [];
    for (final transaction in items) {
      if (!methods.contains(transaction.method)) {
        methods.add(transaction.method);
      }
    }
    return methods;
  }

  TransactionValue calcBalance(
      CurrencyProvider currencyProvider, Currency? currency) {
    TransactionValue sum = TransactionValue(0, currency);
    if (currency != null) {
      for (final transaction in items) {
        if (transaction.currency == currency.name) {
          final tv = currencyProvider.getTransactionValue(transaction);
          if (transaction.isWithdrawal || transaction.isCashDeposit) {
            sum.add(tv);
          } else if (transaction.isExpense && transaction.isCash) {
            sum.sub(tv);
          }
        }
      }
    }
    return sum;
  }

  Balance caluculateAll(CurrencyProvider currencyProvider) {
    var balance = Balance(currencyProvider: currencyProvider);
    for (final transaction in items) {
      balance.add(transaction);
    }
    return balance;
  }

  Balance caluculateExpensesPerDay(CurrencyProvider currencyProvider) {
    var balance = Balance(currencyProvider: currencyProvider);
    for (final transaction in items) {
      if (transaction.isExpense && !transaction.exlcudeFromAverage) {
        balance.add(transaction);
      }
    }

    if (items.isNotEmpty) {
      var start = items.first.groupDate;
      var end = items.last.groupDate;
      balance.days = end.difference(start).inDays + 1;

      balance.expenseAll.value /= balance.days;
      balance.expenseCash.value /= balance.days;
      balance.expenseCard.value /= balance.days;

      balance.expenseByMethodCurrencyCash.forEach((key, tv) {
        tv.value /= balance.days;
      });

      balance.expenseByMethod.forEach((key, tv) {
        tv.value /= balance.days;
      });

      balance.expenseByMethodCurrencyCard.forEach((key2, tv) {
        tv.value /= balance.days;
      });
    }

    return balance;
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
