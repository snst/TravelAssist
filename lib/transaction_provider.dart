import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/currency.dart';
import 'package:travel_assist/currency_provider.dart';
import 'package:travel_assist/transaction_value.dart';
import 'storage.dart';
import 'transaction.dart';

class Balance {
  Currency currency;
  TransactionValue? cardDeposits;
  TransactionValue? cashDeposits;
  TransactionValue? allDeposits;
  TransactionValue? cardExpenses;
  TransactionValue? cashExpenses;
  TransactionValue? allExpenses;
  TransactionValue? cashBalance;

  Balance({required this.currency}) {
    reset();
  }

  void reset() {
    cardDeposits = TransactionValue(0, currency);
    cashDeposits = TransactionValue(0, currency);
    allDeposits = TransactionValue(0, currency);
    cardExpenses = TransactionValue(0, currency);
    cashExpenses = TransactionValue(0, currency);
    allExpenses = TransactionValue(0, currency);
    cashBalance = TransactionValue(0, currency);
  }

  void add(Transaction transaction, TransactionValue tv) {
    if (transaction.isDeposit) {
      if (transaction.isCash) {
        cashDeposits!.add(tv);
      } else {
        cardDeposits!.add(tv);
      }
      allDeposits!.add(tv);
      cashBalance!.add(tv);
    } else {
      if (transaction.isCash) {
        cashExpenses!.add(tv);
        cashBalance!.sub(tv);
      } else {
        cardExpenses!.add(tv);
      }
      allExpenses!.add(tv);
    }
  }
}

class TransactionProvider extends ChangeNotifier with Storage {
  final Map<String, Balance> balancePerCurrency = HashMap<String, Balance>();
  final Map<String, Balance> balancePerMethod = HashMap<String, Balance>();
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

  List<String> getUsedPaymentMethods() {
    List<String> methods = [];
    for (final transaction in items) {
      if (!methods.contains(transaction.method)) {
        methods.add(transaction.method);
      }
    }
    return methods;
  }

  void caluculateAll(CurrencyProvider currencyProvider) {
    final homeCurrency = currencyProvider.getHomeCurrency();
    final usedMethods = getUsedPaymentMethods();
    balancePerCurrency.clear();
    balancePerMethod.clear();

    String sumAllHomeCurrency = 'Sum';// in ' + homeCurrency!.name;

    balancePerCurrency[sumAllHomeCurrency] = Balance(currency: homeCurrency!);
    for (final currency in currencyProvider.visibleItems) {
      balancePerCurrency[currency.name] = Balance(currency: currency);
    }
    for (final method in usedMethods) {
      balancePerMethod[method] = Balance(currency: homeCurrency!);
    }

    for (final transaction in items) {
      final tv = currencyProvider.getTransactionValue(transaction);

      balancePerCurrency[transaction.currencyString]?.add(transaction, tv);
      balancePerMethod[transaction.method]?.add(transaction, tv);
      balancePerCurrency[sumAllHomeCurrency]!.add(transaction, tv);
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
