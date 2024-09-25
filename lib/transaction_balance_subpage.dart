import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_assist/balance.dart';
import 'package:travel_assist/balance_row_widget.dart';
import 'package:travel_assist/currency.dart';
import 'package:travel_assist/currency_provider.dart';
import 'package:travel_assist/transaction_value.dart';
import 'package:travel_assist/transaction_provider.dart';

class TransactionBalanceSubPage extends StatefulWidget {
  const TransactionBalanceSubPage({
    super.key,
    required this.transactionProvider,
    required this.currencyProvider,
  });
  final TransactionProvider transactionProvider;
  final CurrencyProvider currencyProvider;

  @override
  State<TransactionBalanceSubPage> createState() =>
      _TransactionBalanceSubPageState();
}

class _TransactionBalanceSubPageState extends State<TransactionBalanceSubPage> {
  final TextStyle _style = const TextStyle(fontSize: 16);
  Currency? homeCurrency;

  TableRow makeRow(String title, TransactionValue? tv, Currency? homeCurrency) {
    return TableRow(children: <Widget>[
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Text("", style: _style)),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Text(tv.toString(), style: _style)),
      TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Text(tv!.convertTo(homeCurrency).toString(), style: _style)),

      //TransactionCell(value: tv, currency: tv!.currency),
    ]);
  }

  TableRow makeRowHeader(String a, {String b = "", String c = ""}) {
    const TextStyle style = TextStyle(fontSize: 18);
    return TableRow(
      children: [
        TableCell(
          child: Text(a, style: style),
        ),
        TableCell(
          child: Text(b, style: style),
        ),
        TableCell(
          child: Text(c, style: style),
        ),
      ],
    );
  }

  void showExpenses(String title, List<Widget> children, Balance balance) {
    // Expenses
    children.add(BalanceRowHeader(
      FontAwesomeIcons.sackDollar,
      title,
      balance.expenseAll.convertTo(homeCurrency),
      Colors.orangeAccent,
    ));

    children.add(BalanceRowWidget(
        text1: 'Cash',
        tv1: null,
        tv2: balance.expenseCash,
        styleEnum: BalanceRowWidgetEnum.subheader));
    balance.expenseByMethodCurrencyCash.forEach((key, tv) {
      children.add(BalanceRowWidget(
          text1: null, tv1: tv, tv2: tv.convertTo(homeCurrency)));
    });

    children.add(BalanceRowWidget(
        text1: 'Card',
        tv1: null,
        tv2: balance.expenseCard,
        styleEnum: BalanceRowWidgetEnum.subheader));
    balance.expenseByMethod.forEach((key, tv) {
      children.add(BalanceRowWidget(
          text1: key,
          tv1: null,
          tv2: tv.convertTo(homeCurrency),
          styleEnum: BalanceRowWidgetEnum.method));

      balance.expenseByMethodCurrencyCard.forEach((key2, tv) {
        if (key2.startsWith(key)) {
          children.add(BalanceRowWidget(
              text1: null, tv1: tv, tv2: tv.convertTo(homeCurrency)));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final tp = widget.transactionProvider;
    var balance = tp.caluculateAll(widget.currencyProvider);
    var expensesPerDay = tp.caluculateExpensesPerDay(widget.currencyProvider);

    homeCurrency = widget.currencyProvider.getHomeCurrency();
    List<Widget> children = [];

    // Cash
    children.add(Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: BalanceRowHeader(
        FontAwesomeIcons.sackDollar,
        "Cash",
        balance.balanceCash.convertTo(homeCurrency),
        Colors.yellowAccent,
      ),
    ));

    balance.balanceByCurrency.forEach((key, tv) {
      children.add(BalanceRowWidget(
          text1: null, tv1: tv, tv2: tv.convertTo(homeCurrency)));
    });

    showExpenses("Expenses", children, balance);
    showExpenses("Ø Expenses (${expensesPerDay.days}d)", children, expensesPerDay);

    // Withdrawal
    children.add(Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: BalanceRowHeader(
        FontAwesomeIcons.sackDollar,
        "Withdrawal",
        balance.withdrawalAll.convertTo(homeCurrency),
        Colors.greenAccent,
      ),
    ));

    balance.withdrawalByMethod.forEach((key, tv) {
      children.add(BalanceRowWidget(
          text1: key, tv1: null, tv2: tv.convertTo(homeCurrency)));

      balance.withdrawalByMethodCurrencyCard.forEach((key2, tv) {
        if (key2.startsWith(key)) {
          children.add(BalanceRowWidget(
              text1: null, tv1: tv, tv2: tv.convertTo(homeCurrency)));
        }
      });
    });

    // Cash deposit
    children.add(Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: BalanceRowHeader(
        FontAwesomeIcons.sackDollar,
        "Cash deposit",
        balance.cashFunds.convertTo(homeCurrency),
        Colors.lightBlueAccent,
      ),
    ));

    balance.cashFundsByCurrency.forEach((key, tv) {
      children.add(BalanceRowWidget(
          text1: null, tv1: tv, tv2: tv.convertTo(homeCurrency)));
    });
/*
    return Column(
      children: [
        CheckboxListTile(
          title: const Text('Average per day'),
          value: showAveragePerDay,
          onChanged: (bool? value) {
            setState(() {
              showAveragePerDay = !showAveragePerDay;
            });
          },
        ),
        SingleChildScrollView(reverse: true, child: Column(children: children)),
      ],
    );*/

      return  SingleChildScrollView(reverse: false, child: Column(children: children));
     
  }
}

class TransactionCell extends StatelessWidget {
  const TransactionCell({
    super.key,
    this.value,
    this.currency,
  });

  final TransactionValue? value;
  final Currency? currency;
  final TextStyle _style = const TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Text(value != null ? value!.convertTo(currency).valueString : "",
            style: _style));
  }
}
