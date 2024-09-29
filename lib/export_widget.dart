import 'package:flutter/material.dart';
import 'travel_assist_utils.dart';

class ExportWidget extends StatelessWidget {
  const ExportWidget({
    super.key,
    required this.name,
    required this.toJson,
    required this.fromJson,
    required this.clearJson,
    //required this.transactionProvider,
  });
  final String name;
//  final TransactionProvider transactionProvider;
  final String Function() toJson;
  final void Function(String?) fromJson;
  final void Function() clearJson;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          child: const Text("Export"),
          onPressed: () {
            saveJson(context, name, toJson() /*transactionProvider.toJson()*/);
          },
        ),
        ElevatedButton(
          child: const Text("Import"),
          onPressed: () {
            Future<String?> jsonData = loadJson();
            jsonData.then((jsonString) { fromJson(jsonString);
              /*transactionProvider.fromJson(jsonString);*/
            });
          },
        ),
        ElevatedButton(
          child: const Text("Clear"),
          onPressed: () { clearJson(); /*transactionProvider.clear();*/},
        ),
      ],
    );
  }
}
