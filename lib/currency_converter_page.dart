import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'currency_provider.dart';
import 'travel_assist_utils.dart';

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key, required this.createDrawer});
  final Drawer Function(BuildContext context) createDrawer;
  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  List<TextEditingController>? controllers;
  List<FocusNode>? focusNodes;

/*
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
*/

  void onChanged(int index, String text, CurrencyProvider currencies) {
    if (controllers != null) {
      double val =  safeConvertToDouble(text);
      for (int j = 0; j < controllers!.length; j++) {
        if (j != index) {
          controllers![j].text = currencies.items[index]
              .convertToString(val, currencies.items[j]);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Currency Converter"),
      ),
      body: Consumer<CurrencyProvider>(
        builder: (context, currencies, child) {
          if (controllers == null ||
              controllers!.length != currencies.items.length) {
            controllers = List.generate(currencies.items.length, (index) => TextEditingController());
            focusNodes = List.generate(currencies.items.length, (index) => FocusNode());
          }
          return ListView.builder(
              shrinkWrap: true,
              itemCount: currencies.items.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                    child: TextFormField(
                      controller: controllers![index],
                      focusNode: focusNodes![index],
                      onChanged: (text) {
                        //_avalueNotifier.value = text;
                        onChanged(index, text, currencies);
                      },
                      style: const TextStyle(
                        fontSize: 30,
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
                          labelText: currencies.items[index].name,
                          labelStyle: const TextStyle(fontSize: 30.0),
                          suffixIcon: IconButton(
                            onPressed: () { controllers![index].clear(); focusNodes![index].requestFocus(); },
                            icon: const Icon(Icons.clear),
                          )),
                    ));
              });
        },
      ),
      drawer: widget.createDrawer(context),
    );
  }
}
