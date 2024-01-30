import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'todo_item.dart';
import 'todo_provider.dart';

class TodoItemPage extends StatefulWidget {
  TodoItemPage({
    super.key,
    required this.newItem,
    required this.item,
  })  : title = newItem ? 'Add item' : 'Edit item',
        modifiedItem = TodoItem.copy(item);

  final bool newItem;
  final String title;
  final TodoItem item;
  final TodoItem modifiedItem;

  @override
  State<TodoItemPage> createState() => _PackedItemPageState();
}

class _PackedItemPageState extends State<TodoItemPage> {
  TodoProvider getPackingList(BuildContext context) {
    return Provider.of<TodoProvider>(context, listen: false);
  }

  void saveAndClose(BuildContext context) {
    if (widget.modifiedItem.name.isNotEmpty) {
      widget.item.update(widget.modifiedItem);
      getPackingList(context).add(widget.item);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    controller.text = widget.modifiedItem.category;
    List<String> categories = getPackingList(context).getCategories();

    return Scaffold(
        appBar: AppBar(
            //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title)),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: TextEditingController()
                      ..text = widget.modifiedItem.name,
                    decoration: const InputDecoration(hintText: 'Name'),
                    onChanged: (value) => widget.modifiedItem.name = value,
                    autofocus: false,
                  ),
                  TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(
                          hintText: 'Category',
                          suffixIcon: IconButton(
                            onPressed: controller.clear,
                            icon: const Icon(Icons.clear),
                          )),
                      controller: controller, //TextEditingController()
                      //..text = widget.modifiedItem.category,
                    ),
                    suggestionsCallback: (pattern) {
                      widget.modifiedItem.category = pattern;

                      List<String> strlist = categories
                          .where((item) => item
                              .toLowerCase()
                              .contains(pattern.toLowerCase()))
                          .toList();
                      if (!strlist.contains(pattern)) {
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
                      setState(() {
                        widget.modifiedItem.category = suggestion;
                      });
                    },
                  ),
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                      child: SpinBox(
                        value: widget.modifiedItem.quantity.toDouble(),
                        decoration: const InputDecoration(
                            constraints: BoxConstraints.tightFor(
                              width: 150,
                            ),
                            labelText: 'Quantity'),
                        onChanged: (value) =>
                            widget.modifiedItem.quantity = value.toInt(),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                      child: SpinBox(
                        value: widget.modifiedItem.used.toDouble(),
                        decoration: const InputDecoration(
                            constraints: BoxConstraints.tightFor(
                              width: 150,
                            ),
                            labelText: 'Used'),
                        onChanged: (value) =>
                            widget.modifiedItem.used = value.toInt(),
                      ),
                    )
                  ]),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
                      child: Center(
                          child: ToggleSwitch(
                        initialLabelIndex: switch (widget.modifiedItem.state) {
                          TodoItemStateEnum.open => 0,
                          TodoItemStateEnum.skipped => 1,
                          TodoItemStateEnum.done => 2
                        },
                        totalSwitches: 3,
                        labels: const ['Open', 'Skipped', 'Done'],
                        onToggle: (index) {
                          widget.modifiedItem.state = switch (index) {
                            0 => TodoItemStateEnum.open,
                            1 => TodoItemStateEnum.skipped,
                            2 => TodoItemStateEnum.done,
                            _ => TodoItemStateEnum.open
                          };
                          //print('switched to: $index');
                          saveAndClose(context);
                        },
                      ))),
                  Row(children: [
                    const Spacer(),
                    if (!widget.newItem)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                        child: IconButton(
                            // Delete
                            iconSize: 30,
                            icon: const Icon(
                              Icons.delete_outline,
                            ),
                            //alignment: Alignment.centerRight,
                            onPressed: () {
                              getPackingList(context).delete(widget.item);
                              //widget.onItemDeleted(widget.item);
                              Navigator.of(context).pop();
                            }),
                      ),
                    /*
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                      child: IconButton(
                          // Cancel
                          iconSize: 30,
                          icon: const Icon(
                            Icons.cancel_outlined,
                          ),
                          //alignment: Alignment.centerRight,
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                      child: IconButton(
                          // Save
                          iconSize: 30,
                          icon: const Icon(
                            Icons.check,
                          ),
                          //alignment: Alignment.centerRight,
                          onPressed: () {
                            saveAndClose(context);
                          }),
                    ),
                  ]),
                  TextField(
                    controller: TextEditingController()
                      ..text = widget.modifiedItem.comment,
                    decoration: const InputDecoration(hintText: 'Comment'),
                    onChanged: (value) => widget.modifiedItem.comment = value,
                    keyboardType: TextInputType.multiline,
                    minLines: 10, //Normal textInputField will be displayed
                    maxLines: 10, // when user presses enter it will adapt to it
                  )
                ])));
  }
}
