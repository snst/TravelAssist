import 'package:flutter/material.dart';
import 'currency.dart';

class CurrencyChooserWidget extends StatelessWidget {
  CurrencyChooserWidget({
    super.key,
    required this.currencies,
    required this.selected,
    required this.onChanged,
    this.style
  });

  final List<Currency> currencies;
  final Currency? selected;
  final void Function(Currency currency) onChanged;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Currency>(
      value: selected,
      //icon: const Icon(Icons.arrow_downward),
      //elevation: 16,
      underline: Container(
        height: 2,
      ),
      onChanged: (currency) => onChanged(currency!)
      ,
      items: currencies.map<DropdownMenuItem<Currency>>((Currency value) {
        return DropdownMenuItem<Currency>(
          value: value,
          child: Text(value.toString(), style:style),
        );
      }).toList(),
    );
  }
}
