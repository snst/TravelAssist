import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

/*
  Widget createSection(String title, Balance balance, Currency? currency) {
    currency ??= widget.currencyProvider.getHomeCurrency();
    return Table(
      children: [
        TableRow(children: <Widget>[
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Text(title, style: _style)),
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Text(currency.toString(), style: _style)),
        ]),
        if (!balance.allDeposits!.isZero()) ...[
          makeRow("all deposit", balance.allDeposits!.convertTo(currency))
        ],
        if (!balance.cardDeposits!.isZero()) ...[
          makeRow("card deposit", balance.cardDeposits!.convertTo(currency))
        ],
        if (!balance.cashDeposits!.isZero()) ...[
          makeRow("cash deposit", balance.cashDeposits!.convertTo(currency))
        ],
        if (!balance.allExpenses!.isZero()) ...[
          makeRow("Expenses all", balance.allExpenses!.convertTo(currency))
        ],
        if (!balance.cardExpenses!.isZero()) ...[
          makeRow("Expenses card", balance.cardExpenses!.convertTo(currency))
        ],
        if (!balance.cashExpenses!.isZero()) ...[
          makeRow("Expenses cash", balance.cashExpenses!.convertTo(currency))
        ],
        if (!balance.cashBalance!.isZero()) ...[
          makeRow("cash balance", balance.cashBalance!.convertTo(currency))
        ],
      ],
    );
  }
*/
  @override
  Widget build(BuildContext context) {
    final tp = widget.transactionProvider;
    var balance = tp.caluculateAll(widget.currencyProvider);
    
    final homeCurrency = widget.currencyProvider.getHomeCurrency();
    const styleHeader = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20, // Optional: specify font size
    );

    List<Widget> children = [];

    // Cash
    children.add(Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: BalanceRowHeader(
        FontAwesomeIcons.sackDollar,
        "Cash",
        balance.balanceCash.convertTo(homeCurrency),
        Colors.greenAccent,
      ),
    ));

    balance.balanceByCurrency.forEach((key, tv) {
      children.add(BalanceRowWidget(
          text1: null, tv1: tv, tv2: tv.convertTo(homeCurrency)));
    });    

    // Expenses
    children.add(BalanceRowHeader(
      FontAwesomeIcons.sackDollar,
      "Expenses",
      balance.expenseAll.convertTo(homeCurrency),
      Colors.redAccent,
    ));

    children.add(BalanceRowWidget(
        text1: 'Cash', tv1: null, tv2: balance.expenseCash, styleEnum: BalanceRowWidgetEnum.subheader));
    balance.expenseByMethodCurrencyCash.forEach((key, tv) {
      children.add(BalanceRowWidget(
          text1: null, tv1: tv, tv2: tv.convertTo(homeCurrency)));
    });

    children.add(BalanceRowWidget(
        text1: 'Card', tv1: null, tv2: balance.expenseCard, styleEnum: BalanceRowWidgetEnum.subheader));
    balance.expenseByMethod.forEach((key, tv) {
      children.add(BalanceRowWidget(
          text1: key, tv1: null, tv2: tv.convertTo(homeCurrency), styleEnum: BalanceRowWidgetEnum.method));

      balance.expenseByMethodCurrencyCard.forEach((key2, tv) {
        if (key2.startsWith(key)) {
          children.add(BalanceRowWidget(
              text1: null, tv1: tv, tv2: tv.convertTo(homeCurrency)));
        }
      });
    });

    // Withdrawal
    children.add(Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: BalanceRowHeader(
        FontAwesomeIcons.sackDollar,
        "Withdrawal",
        balance.withdrawalAll.convertTo(homeCurrency),
        Colors.blueAccent,
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


    // Cash funds
    children.add(Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: BalanceRowHeader(
        FontAwesomeIcons.sackDollar,
        "Cash funds",
        balance.cashFunds.convertTo(homeCurrency),
        Colors.lightBlueAccent,
      ),
    ));

    balance.cashFundsByCurrency.forEach((key, tv) {
          children.add(BalanceRowWidget(
              text1: null, tv1: tv, tv2: tv.convertTo(homeCurrency)));
    });

    return SingleChildScrollView(
        reverse: true, child: Column(children: children));

    /*
    final currencyAll = selCurrencyAll;
    List<Widget> children = [];

    // tp.balancePerCurrency.forEach((k, v) => children.add(
    //     createSection(k, v, widget.currencyProvider.getCurrencyByName(k))));

    List<TableRow> rowsAllDeposits = [makeRowHeader('All Deposits', c:tp.balancePerCurrency['Sum']!.allDeposits!.toString())];
    List<TableRow> rowsCardDeposits = [makeRowHeader('Card Deposits', c:tp.balancePerCurrency['Sum']!.cardDeposits!.toString())];
    List<TableRow> rowsCashDeposits = [makeRowHeader('Cash Deposits', c:tp.balancePerCurrency['Sum']!.cashDeposits!.toString())];
    List<TableRow> rowsAllExpenses = [makeRowHeader('All Expenses', c:tp.balancePerCurrency['Sum']!.allExpenses!.toString())];
    List<TableRow> rowsCardExpenses = [makeRowHeader('Card Expenses', c:tp.balancePerCurrency['Sum']!.cardExpenses!.toString())];
    List<TableRow> rowsCashExpenses = [makeRowHeader('Cash Expenses', c:tp.balancePerCurrency['Sum']!.cashExpenses!.toString())];
    List<TableRow> rowsCashBalance = [makeRowHeader('Cash Balance', c:tp.balancePerCurrency['Sum']!.cashBalance!.toString())];

    tp.balancePerCurrency.forEach((currencyName, balance) {
      if (currencyName != 'Sum') {
        if (!balance.allDeposits!.isZero()) {
          rowsAllDeposits.add(makeRow(currencyName, balance.allDeposits, currencyAll));
        }
        if (!balance.cardDeposits!.isZero()) {
          rowsCardDeposits.add(makeRow(currencyName, balance.cardDeposits, currencyAll));
        }
        if (!balance.cashDeposits!.isZero()) {
          rowsCashDeposits.add(makeRow(currencyName, balance.cashDeposits, currencyAll));
        }
        if (!balance.allExpenses!.isZero()) {
          rowsAllExpenses.add(makeRow(currencyName, balance.allExpenses, currencyAll));
        }
        if (!balance.cardExpenses!.isZero()) {
          rowsCardExpenses.add(makeRow(currencyName, balance.cardExpenses, currencyAll));
        }
        if (!balance.cashExpenses!.isZero()) {
          rowsCashExpenses.add(makeRow(currencyName, balance.cashExpenses, currencyAll));
        }
        if (!balance.cashBalance!.isZero()) {
          rowsCashBalance.add(makeRow(currencyName, balance.cashBalance, currencyAll));
        }
      }
    });

    children.add(Table(
      children: rowsAllExpenses +
          rowsCashExpenses +
          rowsCardExpenses +
          rowsAllDeposits +
          rowsCardDeposits +
          rowsCashDeposits +
          rowsCashBalance,
    ));

    return Column(
      children: children,
    );
    */
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
