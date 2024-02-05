import 'package:flutter/material.dart';
import 'package:travel_assist/currency_chooser_widget.dart';
import 'package:travel_assist/currency_provider.dart';
import 'package:travel_assist/transaction_value.dart';
import 'currency.dart';

class TransactionValueWidget extends StatefulWidget {
  TransactionValueWidget({
    super.key,
    required this.value,
    required this.currencyProvider,
    this.style
  }) : selected = value.currency;

  Currency? selected;
  TransactionValue value;
  CurrencyProvider currencyProvider;
  TextStyle? style;

  @override
  State<TransactionValueWidget> createState() => _TransactionValueWidgetState();
}

class _TransactionValueWidgetState extends State<TransactionValueWidget> {

  void onChanged( Currency currency) {
    setState(() {
      widget.selected = currency;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0,0,6,0),
          child: Text(widget.value.convertTo(widget.selected).valueString, style: widget.style,),
        ),
        CurrencyChooserWidget(
            currencies: widget.currencyProvider.items,
            selected: widget.selected,
            onChanged: onChanged,
            style: widget.style,)
      ],
    );
  }
}
