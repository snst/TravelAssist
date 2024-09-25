import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/widget_combobox.dart';
import 'todo_item.dart';
import 'todo_provider.dart';

class TodoItemEditPage extends StatefulWidget {
  TodoItemEditPage({
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
  State<TodoItemEditPage> createState() => _PackedItemPageState();
}

class _PackedItemPageState extends State<TodoItemEditPage> {
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
        appBar: /*AppBar(
            //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title)),*/
            AppBar(
          automaticallyImplyLeading: false,
          title: TextField(
            controller: TextEditingController()
              ..text = widget.modifiedItem.name,
            decoration: const InputDecoration(hintText: 'Name'),
            onChanged: (value) => widget.modifiedItem.name = value,
            autofocus: widget.newItem,
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  WidgetComboBox(
                    controller: TextEditingController(),
                    selectedText: widget.modifiedItem.category,
                    hintText: 'Category',
                    filter:true,
                    onChanged: (suggestion) {
                      setState(() {
                        widget.modifiedItem.category = suggestion;
                      });
                    },
                    items: categories,
                  ),
                  /*
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
                  */
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
                    padding: const EdgeInsets.fromLTRB(0, 18, 0, 12),
                    child: SegmentedButton<TodoItemStateEnum>(
                      showSelectedIcon: false,
                      segments: const <ButtonSegment<TodoItemStateEnum>>[
                        ButtonSegment<TodoItemStateEnum>(
                          value: TodoItemStateEnum.skipped,
                          label: Text('skipped'),
                          //  icon: Icon(Icons.calendar_view_week)
                        ),
                        ButtonSegment<TodoItemStateEnum>(
                          value: TodoItemStateEnum.open,
                          label: Text('open'),
                          // icon: Icon(Icons.calendar_view_day)
                        ),
                        ButtonSegment<TodoItemStateEnum>(
                          value: TodoItemStateEnum.done,
                          label: Text('done'),
                          //  icon: Icon(Icons.calendar_view_month)
                        ),
                      ],
                      selected: <TodoItemStateEnum>{widget.modifiedItem.state},
                      onSelectionChanged:
                          (Set<TodoItemStateEnum> newSelection) {
                        setState(() {
                          widget.modifiedItem.state = newSelection.first;
                        });
                        if (!widget.newItem) {
                          saveAndClose(context);
                        }
                      },
                    ),
                  ),
                  Row(children: [
                    const Spacer(),
                    IconButton(
                        // Back
                        iconSize: 30,
                        icon: const Icon(
                          Icons.arrow_back,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    // const Spacer(),
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
