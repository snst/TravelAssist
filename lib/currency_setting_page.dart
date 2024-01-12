import 'package:flutter/material.dart';
import 'currency.dart';

class CurrencySettingPage extends StatefulWidget {
  CurrencySettingPage({super.key});

  @override
  State<CurrencySettingPage> createState() => _CurrencySettingPageState();
}

class _CurrencySettingPageState extends State<CurrencySettingPage> {
  Future<void> _showAlertDialog(BuildContext context, CurrencyList currencyList,
      Currency? currency) async {
    TextEditingController numberController = TextEditingController();
    TextEditingController stringController = TextEditingController();
    if (currency != null) {
      numberController.text = currency.value.toString();
      stringController.text = currency.name;
    }
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Currency'),
          content: Column(
            children: [
              TextField(
                controller: numberController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Enter value'),
              ),
              TextField(
                controller: stringController,
                decoration: InputDecoration(labelText: 'Enter symbol'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the AlertDialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Access the entered values
                String enteredNumber = numberController.text;
                String enteredString = stringController.text;
                Navigator.of(context).pop(); // Close the AlertDialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //final TextEditingController controller = TextEditingController();
    //controller.text = widget.item.category;

    return Scaffold(
      appBar: AppBar(
          //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Currencies")),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: TextEditingController()..text = "€",
                  decoration: const InputDecoration(hintText: 'Name'),
                  onChanged: (value) => {},
                  autofocus: false,
                ),
              ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //_showAlertDialog(context, widget._currencyList, null);
        },
        tooltip: 'Add currency',
        child: const Icon(Icons.add),
      ),
    );
  }
}
