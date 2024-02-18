import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/currency.dart';
import 'package:travel_assist/transaction_value.dart';
import 'currency_provider.dart';
import 'travel_assist_utils.dart';
import 'calculator.dart';

class CurrencyConverterWidget extends StatefulWidget {
  const CurrencyConverterWidget({super.key, required this.currencyProvider});

  final CurrencyProvider currencyProvider;
  @override
  State<CurrencyConverterWidget> createState() =>
      _CurrencyConverterWidgetState();
}

class _CurrencyConverterWidgetState extends State<CurrencyConverterWidget> {
  List<TextEditingController>? controllers;
  List<FocusNode>? focusNodes;
  double _currentValue = 0;
  Currency? _currentCurrency;
  Calculator? calculator;

  void onChanged(int index, String text, CurrencyProvider cp) {
    if (controllers != null) {
      double val = safeConvertToDouble(text);
      _currentValue = val;
      _currentCurrency = cp.visibleItems[index];
      for (int j = 0; j < controllers!.length; j++) {
        if (j != index) {
          controllers![j].text =
              cp.visibleItems[index].convertToString(val, cp.visibleItems[j]);
        }
      }
    }
  }

  void clearAllInputs() {
    if (controllers != null) {
      for (final controller in controllers!) {
        controller.clear();
      }
    }
  }

  void pushValue() {
    if (_currentCurrency != null) {
      calculator?.pushValue(TransactionValue(_currentValue, _currentCurrency));
    }
    clearAllInputs();
    _currentCurrency = null;
  }

  @override
  Widget build(BuildContext context) {
    calculator ??= context.watch<Calculator>();

    if (controllers == null ||
        controllers!.length != widget.currencyProvider.visibleItems.length) {
      controllers = List.generate(widget.currencyProvider.visibleItems.length,
          (index) => TextEditingController());
      focusNodes = List.generate(
          widget.currencyProvider.visibleItems.length, (index) => FocusNode());
    }
    const buttonStyle = TextStyle(fontSize: 30);
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: widget.currencyProvider.visibleItems.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                  child: TextFormField(
                    controller: controllers![index],
                    focusNode: focusNodes![index],
                    onChanged: (text) {
                      //_avalueNotifier.value = text;
                      onChanged(index, text, widget.currencyProvider);
                    },
                    style: const TextStyle(
                      fontSize: 15,
                      //color: Colors.blue.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                    autocorrect: false,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                    ],
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText:
                            widget.currencyProvider.visibleItems[index].name,
                        labelStyle: const TextStyle(fontSize: 25),
                        suffixIcon: IconButton(
                          onPressed: () {
                            controllers![index].clear();
                            focusNodes![index].requestFocus();
                          },
                          icon: const Icon(Icons.clear),
                        )),
                  ));
            }),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                calculator!.inputString,
                style: const TextStyle(fontSize: 20),
              )),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                calculator!.sum.toString(),
                style: const TextStyle(fontSize: 20),
              )),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
              child: OutlinedButton(
                  onLongPress: () {
                    calculator?.clear();
                    clearAllInputs();
                  },
                  onPressed: () {
                    calculator?.back();
                    clearAllInputs();
                  },
                  child: const Text(
                    "C",
                    style: buttonStyle,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: OutlinedButton(
                  onPressed: () {
                    pushValue();
                    calculator?.add();
                  },
                  child: const Text(
                    "+",
                    style: buttonStyle,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: OutlinedButton(
                  onPressed: () {
                    pushValue();
                    calculator?.subtract();
                  },
                  child: const Text(
                    "-",
                    style: buttonStyle,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: OutlinedButton(
                  onPressed: () {
                    pushValue();
                    calculator?.calculate();
                  },
                  child: const Text(
                    "=",
                    style: buttonStyle,
                  )),
            )
          ],
        ),
      ],
    );
  }
}
