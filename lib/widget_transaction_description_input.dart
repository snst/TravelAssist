import 'package:flutter/material.dart';
import 'package:travel_assist/transaction_edit_page.dart';

class WidgetTransactionDescriptionInput extends StatelessWidget {
  const WidgetTransactionDescriptionInput({
    super.key,
    required this.widget,
  });

  final TransactionEditPage widget;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController()..text = widget.modifiedItem.name,
      decoration: const InputDecoration(hintText: 'Description'),
      onChanged: (value) => widget.modifiedItem.name = value,
      autofocus: false,
    );
  }
}
