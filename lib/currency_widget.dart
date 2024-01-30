import 'package:flutter/material.dart';
import 'currency.dart';

class CurrencyWidget extends StatelessWidget {
  CurrencyWidget({
    super.key,
    required this.currencies,
    required this.selected,
    required this.onChanged,
  });

  final List<Currency> currencies;
  final Currency selected;
  final void Function(Currency currency) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Currency>(
      value: selected,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      //style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        //color: Colors.deepPurpleAccent,
      ),
      onChanged: (currency) => onChanged(currency!)
      ,
      items: currencies.map<DropdownMenuItem<Currency>>((Currency value) {
        return DropdownMenuItem<Currency>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
    );
  }
}
