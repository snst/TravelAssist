import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'currency_provider.dart';
import 'travel_assist_utils.dart';

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

  void onChanged(int index, String text, CurrencyProvider currencies) {
    if (controllers != null) {
      double val = safeConvertToDouble(text);
      for (int j = 0; j < controllers!.length; j++) {
        if (j != index) {
          controllers![j].text =
              currencies.visibleItems[index].convertToString(val, currencies.visibleItems[j]);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controllers == null ||
        controllers!.length != widget.currencyProvider.visibleItems.length) {
      controllers = List.generate(widget.currencyProvider.visibleItems.length,
          (index) => TextEditingController());
      focusNodes = List.generate(
          widget.currencyProvider.visibleItems.length, (index) => FocusNode());
    }
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.currencyProvider.visibleItems.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
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
                    labelText: widget.currencyProvider.visibleItems[index].name,
                    labelStyle: const TextStyle(fontSize: 30.0),
                    suffixIcon: IconButton(
                      onPressed: () {
                        controllers![index].clear();
                        focusNodes![index].requestFocus();
                      },
                      icon: const Icon(Icons.clear),
                    )),
              ));
        });
  }
}
