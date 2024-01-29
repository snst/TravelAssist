import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'currency.dart';
import 'settings_model.dart';

class CurrencySettingPage extends StatefulWidget {
  CurrencySettingPage({super.key, required this.createDrawer});
  final Drawer Function(BuildContext context) createDrawer;

  @override
  State<CurrencySettingPage> createState() => _CurrencySettingPageState();
}

class _CurrencySettingPageState extends State<CurrencySettingPage> {
  SettingsModel getSettings(BuildContext context) {
    return Provider.of<SettingsModel>(context, listen: false);
  }

  Future<void> _showCurrencyDialog(
      BuildContext context, Currency currency) async {
    TextEditingController numberController = TextEditingController();
    TextEditingController stringController = TextEditingController();
    numberController.text = currency.value.toString();
    stringController.text = currency.name;
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
            if (currency.key != null)
              TextButton(
                onPressed: () {
                  getSettings(context).deleteCurrency(currency);
                  Navigator.of(context).pop(); // Close the AlertDialog
                },
                child: Text('Delete'),
              ),
            TextButton(
              onPressed: () {
                currency.name = stringController.text;
                currency.value = double.parse(numberController.text);
                if (getSettings(context).addCurrency(currency)) {
                  Navigator.of(context).pop(); // Close the AlertDialog
                }
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
    return Scaffold(
      appBar: AppBar(title: const Text("Currencies")),
      body: Consumer<SettingsModel>(builder: (context, settings, child) {
        settings.load();
        return ListView.builder(
          itemCount: settings.currencies.length,
          itemBuilder: (context, index) => ListTile(
            /*leading: const Icon(Icons.done),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                //cart.remove(cart.items[index]);
              },
            ),*/
            onTap: () {
              _showCurrencyDialog(context, settings.currencies[index]);
            },
            title: Text(
                '${settings.currencies[index].value} ${settings.currencies[index].name}'
                //cart.items[index].name,
                //style: itemNameStyle,
                ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCurrencyDialog(context, Currency());
        },
        tooltip: 'Add currency',
        child: const Icon(Icons.add),
      ),
      drawer: widget.createDrawer(context),
    );
  }
}
