import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/currency_provider.dart';
import 'package:travel_assist/transaction_value.dart';
import 'storage.dart';
import 'transaction.dart';

class Balance {
  CurrencyProvider currencyProvider;
  final Map<String, TransactionValue> expenseByMethod =
      HashMap<String, TransactionValue>();
  final Map<String, TransactionValue> expenseByMethodCurrencyCard =
      HashMap<String, TransactionValue>();
  final Map<String, TransactionValue> expenseByMethodCurrencyCash =
      HashMap<String, TransactionValue>();

  final Map<String, TransactionValue> balanceByCurrency =
      HashMap<String, TransactionValue>();

  final Map<String, TransactionValue> depositByCurrency =
      HashMap<String, TransactionValue>();

  final Map<String, TransactionValue> withdrawalByMethod =
      HashMap<String, TransactionValue>();
  final Map<String, TransactionValue> withdrawalByMethodCurrencyCard =
      HashMap<String, TransactionValue>();

  late TransactionValue expenseAll;
  late TransactionValue balanceCash;
  late TransactionValue expenseCash;
  late TransactionValue expenseCard;
  late TransactionValue withdrawalAll;

  TransactionValue initTransaction() {
    return TransactionValue(0, currencyProvider.getHomeCurrency());
  }

  Balance({required this.currencyProvider}) {
    expenseAll = initTransaction();
    expenseCash = initTransaction();
    expenseCard = initTransaction();
    balanceCash = initTransaction();
    withdrawalAll = initTransaction();
  }

  void initMap(Map<String, TransactionValue> map, final Transaction transaction,
      {var key}) {
    key ??= transaction.currency;
    if (!map.containsKey(key)) {
      map[key] = TransactionValue(
          0, currencyProvider.getCurrencyByName(transaction.currency));
    }
  }

  void add(final Transaction transaction) {
    final tv = currencyProvider.getTransactionValue(transaction);

    if (transaction.isExpense) {
      if (transaction.isCash) {
        balanceCash.sub(tv);
        expenseCash.add(tv);

        initMap(balanceByCurrency, transaction);
        balanceByCurrency[transaction.currency]!.sub(tv);
      } else {
        expenseCard.add(tv);
      }

      String key = '${transaction.method} ${transaction.currencyString}';
      if (transaction.isCash) {
        initMap(expenseByMethodCurrencyCash, transaction, key: key);
        expenseByMethodCurrencyCash[key]!.add(tv);
      } else {
        initMap(expenseByMethodCurrencyCard, transaction, key: key);
        expenseByMethodCurrencyCard[key]!.add(tv);

        if (!expenseByMethod.containsKey(transaction.method)) {
          expenseByMethod[transaction.method] = initTransaction();
        }
        expenseByMethod[transaction.method]!.add(tv);
      }

      expenseAll.add(tv);
    } else if (transaction.isDeposit) {
      initMap(depositByCurrency, transaction);
      depositByCurrency[transaction.currency]!.add(tv);

      balanceCash.add(tv);

      initMap(balanceByCurrency, transaction);
      balanceByCurrency[transaction.currency]!.add(tv);

      if (transaction.isWithdrawal) {
        withdrawalAll.add(tv);
        initMap(withdrawalByMethod, transaction, key:transaction.method);
        withdrawalByMethod[transaction.method]!.add(tv);

        String key = '${transaction.method} ${transaction.currencyString}';
        initMap(withdrawalByMethodCurrencyCard, transaction, key:key);
        withdrawalByMethodCurrencyCard[key]!.add(tv);
      }
    }
  }
}

/*

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

*/

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

  Balance caluculateAll(CurrencyProvider currencyProvider) {
    var balance = Balance(currencyProvider: currencyProvider);
    for (final transaction in items) {
      balance.add(transaction);
    }
    return balance;

    /*
    final homeCurrency = currencyProvider.getHomeCurrency();
    final usedMethods = getUsedPaymentMethods();
    balancePerCurrency.clear();
    balancePerMethod.clear();
    balancePerMethodAndCurrency.clear();

    String sumAllHomeCurrency = 'Sum';
    balancePerCurrency[sumAllHomeCurrency] = Balance(currency: homeCurrency!);
*/
/*    for (final currency in currencyProvider.visibleItems) {
      balancePerCurrency[currency.name] = Balance(currency: currency);
    }
    for (final method in usedMethods) {
      balancePerMethod[method] = Balance(currency: homeCurrency!);
    }
    */
/*
    for (final transaction in items) {
      final tv = currencyProvider.getTransactionValue(transaction);
      String key = '${transaction.method} ${transaction.currencyString}';
      if (!balancePerMethodAndCurrency.containsKey(key)) {
        balancePerMethodAndCurrency[key] = Balance(currency: currencyProvider.getCurrencyByName(transaction.currency)!);
      }
      balancePerMethodAndCurrency[key]!.add(transaction, tv);

      if (!balancePerMethod.containsKey(transaction.method)) {
        balancePerMethod[transaction.method] = Balance(currency: homeCurrency);
      }

      //balancePerCurrency[transaction.currencyString]?.add(transaction, tv);
      balancePerMethod[transaction.method]?.add(transaction, tv);
      balancePerCurrency[sumAllHomeCurrency]!.add(transaction, tv);
    }
    */
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
