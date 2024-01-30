import 'package:isar/isar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/currency.dart';
import 'package:travel_assist/currency_provider.dart';
import 'package:intl/intl.dart';
part 'transaction.g.dart';

// flutter packages pub run build_runner build

enum TransactionTypeEnum {
  inpayment,
  expense,
  balance;
}

@collection
class Transaction {
  Transaction(
      {this.name = "",
      this.value = 0.0,
      this.currencyKey = 0,
      this.type = TransactionTypeEnum.expense,
      this.currency,
      required DateTime date,
      this.method = 0,
      this.categoryKey = 0,
      this.comment = ""})
      : this.date = date;

  Id id = Isar.autoIncrement;
  String name;
  double value;
  int currencyKey;
  DateTime date;
  int method;
  int categoryKey;
  String comment;
  @enumerated
  TransactionTypeEnum type;
  @ignore
  Currency? currency;

  @override
  String toString() {
    return "$date $type: $value ${currency!.name} $name";
  }

  void setCurrency(Currency currency) {
    this.currency = currency;
    this.currencyKey = currency.id;
  }

  double convertTo(Currency targetCurrency) =>
      currency!.convertTo(value, targetCurrency);

  String get dateString => DateFormat('EEEE, d MMMM y').format(date);

  String get valueStr => Currency.formatValue(value);

  DateTime get groupDate {
    return date.copyWith(
        hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
  }

  String getValueStrInCurrency(Currency targetCurrency) {
    return Currency.formatValue(convertTo(targetCurrency));
  }

  void update(Transaction other) {
    name = other.name;
    value = other.value;
    currencyKey = other.currencyKey;
    type = other.type;
    date = other.date;
    method = other.method;
    categoryKey = other.categoryKey;
    comment = other.comment;
    currency = other.currency;
  }

  Transaction clone() {
    var item = Transaction(date: date);
    item.update(this);
    return item;
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

      CurrencyProvider settings =
          Provider.of<CurrencyProvider>(context, listen: false);
      Currency dollar = settings.getCurrencyByName("\$");
      Currency eur = settings.getCurrencyByName("€");
      Currency cordoba = settings.getCurrencyByName("C\$");

      transactions.add(Transaction(
          name: "Bus und Bahn",
          currency: dollar,
          value: 4,
          date: DateTime(2023, 1, 14),
          categoryKey: 1));
      transactions.add(Transaction(
          name: "Zopilote",
          currency: eur,
          value: 20.3,
          date: DateTime(2023, 2, 15),
          categoryKey: 3));
      transactions.add(Transaction(
          name: "Cola",
          currency: eur,
          value: 2.3,
          date: DateTime(2023, 1, 15),
          categoryKey: 2));
      transactions.add(Transaction(
          name: "Chips",
          currency: cordoba,
          value: 27,
          date: DateTime(2023, 1, 12),
          categoryKey: 4));
      transactions.add(Transaction(
          name: "Taxi Bla Blub",
          currency: dollar,
          value: 2.3,
          date: DateTime(2023, 1, 15),
          categoryKey: 1));
      transactions.add(Transaction(
          name: "Bratwurst",
          currency: dollar,
          value: 20.3,
          date: DateTime(2023, 2, 15),
          categoryKey: 2));
    }
  }

  void add(Transaction transaction) {
    transactions.add(transaction);
    notifyListeners();
  }

  void delete(Transaction item) {
    transactions.remove(item.id);
    notifyListeners();
  }

  void notifyItemChanged(Transaction item) {
    //transactions.put(item.key, item);
    //transactions.remove(item.key);
    //transactions.add(item);
    //_box?.delete(item.key);
    //_box?.add(item);
    notifyListeners();
  }

  List<Transaction> getTransactions() {
    return transactions;
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
