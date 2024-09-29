import 'package:flutter/material.dart';
import 'globals.dart';
import 'transaction_edit_page.dart';

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
    return TextField(
      controller: TextEditingController()..text = widget.modifiedItem.name,
      decoration: InputDecoration(hintText: hintText, border: BorderStyles.input,),
      onChanged: (value) => widget.modifiedItem.name = value,
      autofocus: false,
      
    );
  }
}
