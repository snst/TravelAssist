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
  final Map<String, TransactionValue> cashFundsByCurrency =
      HashMap<String, TransactionValue>();

  late TransactionValue expenseAll;
  late TransactionValue expenseCash;
  late TransactionValue expenseCard;
  late TransactionValue withdrawalAll;
  late TransactionValue cashFunds;
  late TransactionValue balanceCash;
  int days = 1;

  TransactionValue initTransaction() {
    return TransactionValue(0, currencyProvider.getHomeCurrency());
  }

  Balance({required this.currencyProvider}) {
    expenseAll = initTransaction();
    expenseCash = initTransaction();
    expenseCard = initTransaction();
    balanceCash = initTransaction();
    withdrawalAll = initTransaction();
    cashFunds = initTransaction();
  }

  void initMap(Map<String, TransactionValue> map, final Transaction transaction,
      {var key}) {
    key ??= transaction.currency;
    if (!map.containsKey(key)) {
      map[key] = TransactionValue(
          0, currencyProvider.getCurrencyByName(transaction.currency));
    }
  }

  bool processExpense(
      final Transaction transaction, final TransactionValue tv) {
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
      return true;
    }
    return false;
  }

  bool processDeposit(
      final Transaction transaction, final TransactionValue tv) {
    if (transaction.isDeposit) {
      initMap(depositByCurrency, transaction);
      depositByCurrency[transaction.currency]!.add(tv);

      balanceCash.add(tv);

      initMap(balanceByCurrency, transaction);
      balanceByCurrency[transaction.currency]!.add(tv);

      if (transaction.isWithdrawal) {
        withdrawalAll.add(tv);
        initMap(withdrawalByMethod, transaction, key: transaction.method);
        withdrawalByMethod[transaction.method]!.add(tv);

        String key = '${transaction.method} ${transaction.currencyString}';
        initMap(withdrawalByMethodCurrencyCard, transaction, key: key);
        withdrawalByMethodCurrencyCard[key]!.add(tv);
      } else if (transaction.isCashDeposit) {
        cashFunds.add(tv);
        initMap(cashFundsByCurrency, transaction,
            key: transaction.currencyString);
        cashFundsByCurrency[transaction.currencyString]!.add(tv);
      }
      return true;
    }
    return false;
  }

  void add(final Transaction transaction) {
    final tv = currencyProvider.getTransactionValue(transaction);
    if (!processExpense(transaction, tv)) {
      processDeposit(transaction, tv);
    }
  }
}

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
