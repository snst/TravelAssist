import 'package:flutter/material.dart';
import 'currency_provider.dart';
import 'transaction_value.dart';
import 'transaction_value_widget.dart';

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({
    super.key,
    required this.name,
    required this.transactionValue,
    required this.currencyProvider,
    this.style,
  });
  final String name;
  final TransactionValue transactionValue;
  final CurrencyProvider currencyProvider;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
      child: Row(children: [
        Expanded(child: Text(name, style: style)),
        TransactionValueWidget(
            value: transactionValue,
            currencyProvider: currencyProvider,
            style: style)
      ]),
    );
  }
}
