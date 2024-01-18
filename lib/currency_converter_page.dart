import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'settings_model.dart';

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key, required this.createDrawer});
  final Drawer Function(BuildContext context) createDrawer;
  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  //String? validateCustomInput(String value) {
  // Implement your validation logic here
  //}
  List<TextEditingController>? controllers;

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

  void onChanged(int index, String text, SettingsModel settings) {
    //print("$index : $text");
    if (controllers != null) {
      double val = text == "" ? 0 : double.parse(text);
      for (int j = 0; j < controllers!.length; j++) {
        if (j != index) {
          controllers![j].text = settings.currencies[index]
              .convertToString(val, settings.currencies[j]);
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
      body: Consumer<SettingsModel>(
        builder: (context, settings, child) {
          settings.load();
          if (controllers == null ||
              controllers!.length != settings.currencies.length) {
            controllers = List.generate(settings.currencies.length, (index) => TextEditingController());
          }
          return ListView.builder(
              shrinkWrap: true,
              itemCount: settings.currencies.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                    child: TextFormField(
                      controller: controllers![index],
                      onChanged: (text) {
                        //_avalueNotifier.value = text;
                        onChanged(index, text, settings);
                      },
                      style: TextStyle(
                        fontSize: 30,
                        //color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                      autocorrect: false,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                      ],
                      decoration: InputDecoration(
                          //border: UnderlineInputBorder(),
                          border: OutlineInputBorder(),
                          labelText: settings.currencies[index].name,
                          labelStyle: TextStyle(fontSize: 30.0),
                          suffixIcon: IconButton(
                            onPressed: controllers![index].clear,
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
