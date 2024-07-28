import 'package:flutter/material.dart';
import 'package:travel_assist/transaction_edit_page.dart';

class WidgetTransactionDescriptionInput extends StatelessWidget {
  const WidgetTransactionDescriptionInput({
    super.key,
    required this.widget,
    required this.hintText
  });

  final TransactionEditPage widget;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0,0,0,5),
      child: TextField(
        controller: TextEditingController()..text = widget.modifiedItem.name,
        decoration: InputDecoration(hintText: hintText),
        onChanged: (value) => widget.modifiedItem.name = value,
        autofocus: false,
      ),
    );
  }
}
