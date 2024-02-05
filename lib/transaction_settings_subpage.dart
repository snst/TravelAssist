import 'package:flutter/material.dart';
import 'package:travel_assist/transaction_provider.dart';
import 'package:travel_assist/travel_assist_utils.dart';

class TransactionSettingsSubpage extends StatelessWidget {
  const TransactionSettingsSubpage({
    super.key,
    required this.transactionProvider,
  });
  final TransactionProvider transactionProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          child: Text("Export"),
          onPressed: () {
            saveJson(context, 'transaction.json', transactionProvider.toJson());
          },
        ),
        ElevatedButton(
          child: Text("Import"),
          onPressed: () {
            Future<String?> jsonData = loadJson();
            jsonData.then((jsonString) {
              transactionProvider.fromJson(jsonString);
            });
          },
        ),
        ElevatedButton(
          child: Text("Clear"),
          onPressed: () { transactionProvider.clear();},
        ),
      ],
    );
  }
}
