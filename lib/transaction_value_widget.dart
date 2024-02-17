import 'package:flutter/material.dart';
import 'package:travel_assist/currency.dart';
import 'package:travel_assist/currency_chooser_widget.dart';
import 'package:travel_assist/currency_provider.dart';
import 'package:travel_assist/transaction_value.dart';

class TransactionValueWidget extends StatefulWidget {
  const TransactionValueWidget(
      {super.key,
      required this.value,
      required this.currencyProvider,
      this.style});

  final TransactionValue value;
  final CurrencyProvider currencyProvider;
  final TextStyle? style;

  @override
  State<TransactionValueWidget> createState() => _TransactionValueWidgetState();
}

class _TransactionValueWidgetState extends State<TransactionValueWidget> {
  Currency? selected;

  void onChanged(Currency currency) {
    setState(() {
      selected = currency;
    });
  }

  @override
  Widget build(BuildContext context) {
    selected = widget.value.currency;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
          child: Text(
            widget.value.convertTo(selected).valueString,
            style: widget.style,
          ),
        ),
        CurrencyChooserWidget(
          currencies: widget.currencyProvider.visibleItems,
          selected: selected,
          onChanged: onChanged,
          style: widget.style,
        )
      ],
    );
  }
}
