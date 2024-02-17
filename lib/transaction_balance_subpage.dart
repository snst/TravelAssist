import 'package:flutter/material.dart';
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
  Currency? selCurrencyAll;

  @override
  Widget build(BuildContext context) {
    widget.transactionProvider.caluculateAll(widget.currencyProvider);
    selCurrencyAll ??= widget.currencyProvider.getHomeCurrency();

    final currencyAll = selCurrencyAll;
    var tableRows = <TableRow>[
      const TableRow(children: <Widget>[
        Text("Curreny"),
        Text("Expense"),
        Text("Withdraw"),
        Text("Balance"),
        // Text("Currency")
      ]),
      TableRow(children: <Widget>[
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Text("All", style: _style)),
        TransactionCell(
            value: widget.transactionProvider.allExpenses,
            currency: currencyAll),
        TransactionCell(
            value: widget.transactionProvider.allWithdraws,
            currency: currencyAll),
        TransactionCell(
            value: widget.transactionProvider.allBalance,
            currency: currencyAll),
        /*CurrencyChooserWidget(
            currencies: widget.currencyProvider.items,
            selected: widget.selCurrencyAll,
            onChanged: (sel) {
              setState(() {
                widget.selCurrencyAll = sel;
              });
            })*/
      ])
    ];

    widget.transactionProvider.expensePerCurrency
        .forEach((currencyName, transactionValue) {
      final currency = widget.currencyProvider.getCurrencyByName(currencyName);
      tableRows.add(TableRow(children: <Widget>[
        TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Text(currency.toString(), style: _style)),
        TransactionCell(value: transactionValue, currency: currency),
        TransactionCell(
            value: widget.transactionProvider.withdrawPerCurrency[currencyName],
            currency: currency),
        TransactionCell(
            value: widget.transactionProvider.balancePerCurrency[currencyName],
            currency: currency),
        /* CurrencyChooserWidget(
            style: _style,
            currencies: widget.currencyProvider.items,
            selected: widget.selCurrencyMap[k],
            onChanged: (sel) {
              setState(() {
                widget.selCurrency[k] = sel;
              });
            })*/
      ]));
    });

    return Table(children: tableRows);
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
