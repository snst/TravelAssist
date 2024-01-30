import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/currency_provider.dart';
import 'storage.dart';
import 'transaction.dart';
import 'currency.dart';

class TransactionProvider extends ChangeNotifier with Storage {
  TransactionProvider() {
    db = openDB();
    init();
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

  void initCurrencies(CurrencyProvider cp) {
    for(var t in items) {
      t.currency = cp.getCurrencyById(t.currencyKey);
    }
  }

  void add(Transaction item) async {
    final isar = await db;
    await isar!.writeTxn(() async {
      await isar.transactions.put(item);
      if (!_items.contains(item)) {
        _items.add(item);
      }
      notifyListeners();
    });
  }

  void delete(Transaction item) async {
    final isar = await db;
    await isar!.writeTxn(() async {
      await isar.transactions.delete(item.id);
      _items.remove(item);
      notifyListeners();
    });
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
    /*
      DateTime normalizedDate1 = DateTime(date1.year, date1.month, date1.day);
      DateTime normalizedDate2 = DateTime(date2.year, date2.month, date2.day);
      return normalizedDate1.isAtSameMomentAs(normalizedDate2);
*/
    var ret = a.date.compareTo(b.date);
    //if (ret == 0) {
    //  ret = a.type.index.compareTo(b.type.index);
    //}
    return ret;
  }

  TransactionResult calculate(Currency currency, DateTime? until) {
    TransactionResult result = TransactionResult();
    List<Transaction> items = getSortedTransactions(until);
    for (final item in items) {
      double value = item.convertTo(currency);
      switch (item.type) {
        case TransactionTypeEnum.inpayment:
          result.sumInpayment += value;
          break;
        case TransactionTypeEnum.expense:
          result.sumExpense += value;
          break;
        default:
          break;
      }
    }
    result.balance = result.sumInpayment - result.sumExpense;
    result.days = items.length == 0 ? 1 : items.last.date.difference(items.first.date).inDays + 1;
    result.expensePerDay = result.sumExpense / result.days;
    return result;
  }
}
