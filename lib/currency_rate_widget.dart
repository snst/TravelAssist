import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/travel_assist_utils.dart';
import 'currency.dart';
import 'currency_provider.dart';

class CurrencyRatesPage extends StatefulWidget {
  const CurrencyRatesPage({super.key, required this.currencyProvider});
  final CurrencyProvider currencyProvider;
  @override
  State<CurrencyRatesPage> createState() => _CurrencyRatesPageState();
}

class _CurrencyRatesPageState extends State<CurrencyRatesPage> {
  Future<void> _showEditDialog(
      BuildContext context,
      CurrencyProvider provider,
      Currency currency,
      bool newItem) async {
    TextEditingController numberController = TextEditingController();
    TextEditingController stringController = TextEditingController();
    CurrencyStateEnum currencyState = currency.state;
    numberController.text = currency.value.toString();
    stringController.text = currency.name;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text( '${newItem ? 'Add' : 'Edit'} currency'),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 18, 0, 12),
                  child: Text(switch (currencyState) {
                    CurrencyStateEnum.home => "Home currency",
                    CurrencyStateEnum.hide => "Currency hidden",
                    CurrencyStateEnum.show => "Currency shown"
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: SegmentedButton<CurrencyStateEnum>(
                    showSelectedIcon: false,
                    segments: const <ButtonSegment<CurrencyStateEnum>>[
                      ButtonSegment<CurrencyStateEnum>(
                        value: CurrencyStateEnum.home,
                        //label: Text('home'),
                        icon: FaIcon(FontAwesomeIcons.house),
                      ),
                      ButtonSegment<CurrencyStateEnum>(
                        value: CurrencyStateEnum.show,
                        //label: Text('show'),
                        icon: FaIcon(FontAwesomeIcons.eye),
                      ),
                      ButtonSegment<CurrencyStateEnum>(
                        value: CurrencyStateEnum.hide,
                        //label: Text('hide'),
                        icon: FaIcon(FontAwesomeIcons.eyeSlash),
                      ),
                    ],
                    selected: <CurrencyStateEnum>{currencyState},
                    onSelectionChanged: (Set<CurrencyStateEnum> newSelection) {
                      setState(() {
                        currencyState = newSelection.first;
                      });
                    },
                  ),
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
                    provider.delete(currency);
                    Navigator.of(context).pop(); // Close the AlertDialog
                  },
                  child: const Text('Delete'),
                ),
              TextButton(
                onPressed: () {
                  currency.name = stringController.text;
                  currency.value = safeConvertToDouble(numberController.text);
                  currency.state = currencyState;
                  provider.add(currency);
                  Navigator.of(context).pop(); // Close the AlertDialog
                  //}
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CurrencyProvider>();
    return Scaffold(
      body: ListView.builder(
        itemCount: provider.allItems.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            onTap: () {
              _showEditDialog(context, provider,
                  provider.allItems[index], false);
            },
            leading:
                FaIcon(switch (provider.allItems[index].state) {
              CurrencyStateEnum.home => FontAwesomeIcons.house,
              CurrencyStateEnum.hide => FontAwesomeIcons.eyeSlash,
              _ => FontAwesomeIcons.eye
            }),
            title: Text(
                '${provider.allItems[index].value} ${provider.allItems[index].name}'),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showEditDialog(
              context, provider, Currency(), true);
        },
        tooltip: 'Add currency',
        child: const Icon(Icons.add),
      ),
    );
  }
}
