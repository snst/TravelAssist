import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
//import 'package:travel_assist/travel_assist_utils.dart';
import 'payment_method.dart';
import 'payment_method_provider.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key, required this.provider});
  final PaymentMethodProvider provider;
  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  Future<void> _showEditDialog(
      BuildContext context,
      PaymentMethodProvider provider,
      PaymentMethod paymentMethod,
      bool newItem) async {
    TextEditingController stringController = TextEditingController();
    stringController.text = paymentMethod.name;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text( '${newItem ? 'Add' : 'Edit'} payment method'),
            content: Column(
              children: [
                TextField(
                  controller: stringController,
                  decoration: const InputDecoration(labelText: 'Enter payment name'),
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
                    provider.delete(paymentMethod);
                    Navigator.of(context).pop(); // Close the AlertDialog
                  },
                  child: const Text('Delete'),
                ),
              TextButton(
                onPressed: () {
                  paymentMethod.name = stringController.text;
                  provider.add(paymentMethod);
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
    final provider = context.watch<PaymentMethodProvider>();
    return Scaffold(
      body: ListView.builder(
        itemCount: provider.allItems.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            onTap: () {
              _showEditDialog(context, provider,
                  provider.allItems[index], false);
            },
            title: Text(
                provider.allItems[index].name),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showEditDialog(
              context, provider, PaymentMethod(), true);
        },
        tooltip: 'Add paymentMethod',
        child: const Icon(Icons.add),
      ),
    );
  }
}
