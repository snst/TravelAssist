import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/drawer_widget.dart';
import 'currency.dart';
import 'currency_provider.dart';

class CurrencySettingPage extends StatefulWidget {
  CurrencySettingPage({super.key, required this.currencyProvider});
  CurrencyProvider currencyProvider;

  @override
  State<CurrencySettingPage> createState() => _CurrencySettingPageState();
}

class _CurrencySettingPageState extends State<CurrencySettingPage> {
  CurrencyProvider getSettings(BuildContext context) {
    return Provider.of<CurrencyProvider>(context, listen: false);
  }

  Future<void> _showCurrencyDialog(
      BuildContext context, Currency currency, bool newItem) async {
    TextEditingController numberController = TextEditingController();
    TextEditingController stringController = TextEditingController();
    numberController.text = currency.value.toString();
    stringController.text = currency.name;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Currency'),
          content: Column(
            children: [
              TextField(
                controller: numberController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Enter value'),
              ),
              TextField(
                controller: stringController,
                decoration: const InputDecoration(labelText: 'Enter symbol'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the AlertDialog
              },
              child: const Text('Cancel'),
            ),
            if (!newItem)
              TextButton(
                onPressed: () {
                  getSettings(context).delete(currency);
                  Navigator.of(context).pop(); // Close the AlertDialog
                },
                child: const Text('Delete'),
              ),
            TextButton(
              onPressed: () {
                currency.name = stringController.text;
                currency.value = double.parse(numberController.text);
                getSettings(context).add(currency);
                Navigator.of(context).pop(); // Close the AlertDialog
                //}
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.currencyProvider.items.length,
        itemBuilder: (context, index) => ListTile(
          /*leading: const Icon(Icons.done),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                //cart.remove(cart.items[index]);
              },
            ),*/
          onTap: () {
            _showCurrencyDialog(
                context, widget.currencyProvider.items[index], false);
          },
          title: Text(
              '${widget.currencyProvider.items[index].value} ${widget.currencyProvider.items[index].name}'
              //cart.items[index].name,
              //style: itemNameStyle,
              ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCurrencyDialog(context, Currency(), true);
        },
        tooltip: 'Add currency',
        child: const Icon(Icons.add),
      ),
    );
  }
}
