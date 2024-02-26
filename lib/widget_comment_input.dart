import 'package:flutter/material.dart';

class WidgetCommentInput extends StatelessWidget {
  const WidgetCommentInput({
    super.key,
    required this.comment,
    required this.onChanged,
  });

  final String comment;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController()..text = comment,
      decoration: const InputDecoration(hintText: 'Comment'),
      onChanged: (value) => onChanged(value),
      keyboardType: TextInputType.multiline,
      minLines: 1, //Normal textInputField will be displayed
      maxLines: 8, // when user presses enter it will adapt to it
      //scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      //scrollPadding: EdgeInsets.symmetric( vertical: MediaQuery.of(context).viewInsets.bottom),
    );
  }
}
