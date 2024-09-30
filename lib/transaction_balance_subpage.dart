import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'balance.dart';
import 'balance_row_widget.dart';
import 'currency.dart';
import 'currency_provider.dart';
import 'globals.dart';
import 'transaction_value.dart';
import 'transaction_provider.dart';

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

  void showExpenses(String title, List<Widget> children, Balance balance) {
    // Expenses
    children.add(BalanceRowHeader(
      FontAwesomeIcons.sackDollar,
      title,
      balance.expenseAll.convertTo(homeCurrency),
      AppColors.expense,
    ));

    children.add(BalanceRowWidget(
        text1: 'Cash',
        tv1: null,
        tv2: balance.expenseCash,
        style: AppBalanceStyle.subheader));
    balance.expenseByMethodCurrencyCash.forEach((key, tv) {
      children.add(BalanceRowWidget(
          text1: null,
          tv1: tv,
          tv2: tv.convertTo(homeCurrency),
          style: AppBalanceStyle.normal));
    });

    children.add(BalanceRowWidget(
        text1: 'Card',
        tv1: null,
        tv2: balance.expenseCard,
        style: AppBalanceStyle.subheader));
    balance.expenseByMethod.forEach((key, tv) {
      children.add(BalanceRowWidget(
          text1: "  $key",
          tv1: null,
          tv2: tv.convertTo(homeCurrency),
          style: AppBalanceStyle.method));

      balance.expenseByMethodCurrencyCard.forEach((key2, tv) {
        if (key2.startsWith(key)) {
          children.add(BalanceRowWidget(
              text1: null,
              tv1: tv,
              tv2: tv.convertTo(homeCurrency),
              style: AppBalanceStyle.normal));
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
        "Cash Balance",
        balance.haveCash.convertTo(homeCurrency),
        AppColors.cash,
      ),
    ));

    balance.haveCashByCurrency.forEach((key, tv) {
      children.add(BalanceRowWidget(
          text1: null,
          tv1: tv,
          tv2: tv.convertTo(homeCurrency),
          style: AppBalanceStyle.normal));
    });

    showExpenses("Expenses", children, balance);
    showExpenses(
        "Ø Expenses (${expensesPerDay.days}d)", children, expensesPerDay);

    // Withdrawal
    children.add(Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: BalanceRowHeader(
        FontAwesomeIcons.sackDollar,
        "Withdrawal",
        balance.withdrawalAll.convertTo(homeCurrency),
        AppColors.withdrawal,
      ),
    ));

    balance.withdrawalByMethod.forEach((key, tv) {
      children.add(BalanceRowWidget(
          text1: "  $key",
          tv1: null,
          tv2: tv.convertTo(homeCurrency),
          style: AppBalanceStyle.method));

      balance.withdrawalByMethodCurrencyCard.forEach((key2, tv) {
        if (key2.startsWith(key)) {
          children.add(BalanceRowWidget(
              text1: null,
              tv1: tv,
              tv2: tv.convertTo(homeCurrency),
              style: AppBalanceStyle.normal));
        }
      });
    });

    // Cash deposit
    children.add(Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: BalanceRowHeader(
        FontAwesomeIcons.sackDollar,
        "Cash deposit",
        balance.cashDeposit.convertTo(homeCurrency),
        AppColors.deposit,
      ),
    ));

    balance.cashDepositByCurrency.forEach((key, tv) {
      children.add(BalanceRowWidget(
          text1: null,
          tv1: tv,
          tv2: tv.convertTo(homeCurrency),
          style: AppBalanceStyle.normal));
    });

    // Balance
    children.add(Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: BalanceRowHeader(
        FontAwesomeIcons.sackDollar,
        "Cash Correction",
        balance.balanceCash.convertTo(homeCurrency),
        AppColors.balance,
      ),
    ));

    balance.balanceByCurrency.forEach((key, tv) {
      children.add(BalanceRowWidget(
          text1: null,
          tv1: tv,
          tv2: tv.convertTo(homeCurrency),
          style: AppBalanceStyle.normal));
    });

    children.add(SizedBox(
      height: 100,
    ));

    return SingleChildScrollView(
        reverse: false, child: Column(children: children));
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
