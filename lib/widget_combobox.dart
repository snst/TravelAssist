import 'package:flutter/material.dart';
import 'package:travel_assist/transaction_edit_page.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class WidgetComboBox extends StatelessWidget {
  WidgetComboBox({
    super.key,
    required this.controller,
    required this.selectedText,
    required this.hintText,
    required this.onChanged,
    required this.items,

  });

  final String selectedText;
  final String hintText;
  final Function(String) onChanged;
  final TextEditingController controller;// = TextEditingController();
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    controller.text = selectedText;
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: IconButton(
              onPressed: controller.clear,
              icon: const Icon(Icons.clear),
            )),
        controller: controller, 
      ),
      suggestionsCallback: (pattern) {
        //widget.modifiedItem.category = pattern;
        //onChanged(pattern);

        List<String> strlist = items
            .where((item) => item.toLowerCase().contains(pattern.toLowerCase()))
            .toList();
        
        if (pattern.isNotEmpty && !strlist.contains(pattern)) {
          strlist.insert(0, pattern);
        }
        return strlist;
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      onSuggestionSelected: (suggestion) {
        onChanged(suggestion);
      },
    );
  }
}
