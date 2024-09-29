import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'globals.dart';

class WidgetComboBox extends StatelessWidget {
  WidgetComboBox({
    super.key,
    required this.controller,
    required this.selectedText,
    required this.hintText,
    required this.filter,
    required this.onChanged,
    required this.items,
  });

  final String selectedText;
  final String hintText;
  final Function(String) onChanged;
  final TextEditingController controller;
  final List<String> items;
  final bool filter;
  //final FocusNode _focusNode = FocusNode();
//  final SuggestionsController _suggestionsController();

  @override
  Widget build(BuildContext context) {
    controller.text = selectedText;

    return TypeAheadField<String>(
      controller: controller,
      builder: (context, controller, focusNode) {
        return TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: false,
            decoration: InputDecoration(
                border: BorderStyles.input,
                hintText: hintText,
                suffixIcon: IconButton(
                  onPressed: controller.clear,
                  icon: const Icon(Icons.clear),
                )));
      },
      suggestionsCallback: (pattern) {
        //widget.modifiedItem.category = pattern;
        //onChanged(pattern);

        List<String> strlist;
        if (filter) {
          strlist = items
              .where((item) =>
                  item.isNotEmpty &&
                  item.toLowerCase().contains(pattern.toLowerCase()))
              .toList();
          for (final s in items) {
            if (!strlist.contains(s) && s.isNotEmpty) {
              strlist.add(s);
            }
          }
        } else {
          strlist = items.toList();
        }

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
      onSelected: (suggestion) {
        //print("onSelected11: $suggestion");
        controller.text = suggestion;
        onChanged(suggestion);
      },
    );
  }
}
