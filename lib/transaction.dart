//import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/currency.dart';
import 'package:travel_assist/settings_model.dart';
import 'package:intl/intl.dart';

// flutter packages pub run build_runner build

@HiveType(typeId: 5)
enum TransactionEnum {
  @HiveField(0)
  inpayment,
  @HiveField(1)
  expense,
  @HiveField(2)
  balance;
}

@HiveType(typeId: 3)
class Transaction extends HiveObject {
  Transaction(
      {this.name = "",
      this.value = 0.0,
      this.currencyKey = 0,
      this.type = TransactionEnum.expense,
      this.currency,
      DateTime? date,
      this.method = 0,
      this.categoryKey=0})
      : this.date = date ?? DateTime.now();

  @HiveField(0)
  String name;
  @HiveField(1)
  double value;
  @HiveField(2)
  int currencyKey;
  @HiveField(3)
  TransactionEnum type;
  @HiveField(4)
  DateTime date;
  @HiveField(5)
  int method;
  @HiveField(6)
  int categoryKey;

  Currency? currency;
  final List<String> budgetCatgegories = ['Common', 'Restaurant', 'Food', 'Drink', 'Transport', 'Accomodation', 'Activity'];

  @override
  String toString() {
    return "$date $type: $value ${currency!.name} $name";
  }

  double convertTo(Currency targetCurrency) =>
      currency!.convertTo(value, targetCurrency);

  String get dateString => DateFormat('EEEE, d MMMM y').format(date);

  String get category => budgetCatgegories[categoryKey];

  String get valueStr => Currency.formatValue(value);

  String getValueStrInCurrency(Currency targetCurrency) {
    return Currency.formatValue(convertTo(targetCurrency));
  }
}

class TransactionSum {
  double sum = 0;
  int count = 0;
  Currency currency;
  TransactionSum({required this.currency});

  void add(double val) {
    sum += val;
    count += 1;
  }

  double getSumInCurrency(Currency targetCurrency) {
    return Currency.convert(sum, currency, targetCurrency);
  }
}

class TransactionResult {
  double sumExpense = 0;
  double sumInpayment = 0;
  double balance = 0;
  double expensePerDay = 0;
  int days = 1;
}

class BudgetModel extends ChangeNotifier {
  List<Transaction> transactions = [];
  bool isInit = false;

  void load(BuildContext context) {
    if (!isInit) {
      isInit = true;
      transactions = [];

      SettingsModel settings = Provider.of<SettingsModel>(context, listen: false);
      Currency dollar = settings.getCurrency("\$");
      Currency eur = settings.getCurrency("€");
      Currency cordoba = settings.getCurrency("C\$");

      add(Transaction(name:"Bus und Bahn", currency: dollar, value: 4, date: DateTime(2023, 1, 14), categoryKey: 1));
      add(Transaction(name:"Zopilote", currency: eur, value: 20.3, date: DateTime(2023, 2, 15), categoryKey: 3));
      add(Transaction(name:"Cola", currency: eur, value: 2.3, date: DateTime(2023, 1, 15), categoryKey: 2));
      add(Transaction(name:"Chips", currency: cordoba, value: 27, date: DateTime(2023, 1, 12), categoryKey: 4));
      add(Transaction(name:"Taxi Bla Blub", currency: dollar, value: 2.3, date: DateTime(2023, 1, 15), categoryKey: 1));
      add(Transaction(name:"Bratwurst", currency: dollar, value: 20.3, date: DateTime(2023, 2, 15), categoryKey: 2));
    }
  }

  void add(Transaction transaction) {
    transactions.add(transaction);
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

  List<Transaction> getTransactions() {
    return transactions;
  }

  List<Transaction> getSortedTransactions(DateTime? until) {
    List<Transaction> ret = transactions;
    if (until != null) {
      ret = transactions
          .where((element) => !element.date.isAfter(until))
          .toList();
    }

    ret.sort(transactionComparison);
    return ret;
  }

  TransactionResult calculate(Currency currency, DateTime? until) {
    TransactionResult result = TransactionResult();
    List<Transaction> items = getSortedTransactions(until);
    for (final item in items) {
      double value = item.convertTo(currency);
      switch (item.type) {
        case TransactionEnum.inpayment:
          result.sumInpayment += value;
          break;
        case TransactionEnum.expense:
          result.sumExpense += value;
          break;
        default:
          break;
      }
    }
    result.balance = result.sumInpayment - result.sumExpense;
    result.days = items.last.date.difference(items.first.date).inDays + 1;
    result.expensePerDay = result.sumExpense / result.days;
    return result;
  }

/*
  void initCurrencies(List<Currency> currencies) {
    for (final currency in currencies) {
      _currencySumMap[currency] = TransactionSum(currency: currency);
    }
  }

  void calculate() {
    for (final t in transactions) {
      if (t.type == TransactionEnum.expense) {
        _currencySumMap[t.currency]?.add(t.value);
      }
    }
  }

  double getExpenses(Currency currency) {
    return _currencySumMap[currency]!.sum;
  }

  double getAllExpensesIn(Currency currency) {
    double sum = 0;
    _currencySumMap.forEach((key, value) {
      sum += value.getSumInCurrency(currency);
    });

    return sum;
  }

  void dump() {
    _currencySumMap.forEach((key, value) {
      String str = "${key.name}: ${value.sum}";
      print(str);
    });
  }
  */
}
