import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'packing_list_item.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:toggle_switch/toggle_switch.dart';

class PackedItemPage extends StatefulWidget {
  PackedItemPage(
      {super.key,
      required this.title,
      required this.orgItem,
      required this.item,
      required this.categories,
      //required this.categoryItems,
      required this.onItemModified,
      required this.onItemAdded,
      required this.onItemDeleted});

  final String title;
  final PackingListItem item;
  final PackingListItem? orgItem;
  List<String> categories;
  //List<IconData> categoryItems;
  final void Function(PackingListItem? oldItem, PackingListItem newItem)
      onItemModified;
  final void Function(PackingListItem item) onItemAdded;
  final void Function(PackingListItem item) onItemDeleted;

  @override
  State<PackedItemPage> createState() => _PackedItemPageState();
}

class _PackedItemPageState extends State<PackedItemPage> {
  void saveAndClose() {
    if (widget.item.name.isNotEmpty) {
      if (widget.orgItem == null) {
        widget.onItemAdded(widget.item);
      } else {
        widget.onItemModified(widget.orgItem, widget.item);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      ..text = widget.item.name,
                    decoration: const InputDecoration(hintText: 'Name'),
                    onChanged: (value) => widget.item.name = value,
                    autofocus: false,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Scrollbar(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ToggleSwitch(
                          initialLabelIndex: widget.item.categoryItem,
                          totalSwitches: CategoryIcons.length,
                          customWidths:
                              List.filled(CategoryIcons.length, 40),
                          icons: CategoryIcons,
                          onToggle: (index) {
                            widget.item.categoryItem =
                                (index != null) ? index : 0;
                            //print('switched to: $index');
                          },
                        ),
                      ),
                    ),
                  ),
                  TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(
                        hintText: 'Category',
                      ),
                      controller: TextEditingController()
                        ..text = widget.item.category,
                    ),
                    suggestionsCallback: (pattern) {
                      List<String> strlist = widget.categories
                          .where((fruit) => fruit
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
                        widget.item.category = suggestion;
                      });
                    },
                  ),
                  Row(children: [
                    Padding(
                      child: SpinBox(
                        value: widget.item.quantity.toDouble(),
                        decoration: InputDecoration(
                            constraints: BoxConstraints.tightFor(
                              width: 150,
                            ),
                            labelText: 'Quantity'),
                        onChanged: (value) =>
                            widget.item.quantity = value.toInt(),
                      ),
                      padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                    ),
                    Spacer(),
                    Padding(
                      child: SpinBox(
                        value: widget.item.used.toDouble(),
                        decoration: InputDecoration(
                            constraints: BoxConstraints.tightFor(
                              width: 150,
                            ),
                            labelText: 'Used'),
                        onChanged: (value) => widget.item.used = value.toInt(),
                      ),
                      padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                    )
                  ]),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
                      child: Center(
                          child: ToggleSwitch(
                        initialLabelIndex: switch (widget.item.state) {
                          PackingListItemStateEnum.todo => 0,
                          PackingListItemStateEnum.skipped => 1,
                          PackingListItemStateEnum.packed => 2
                        },
                        totalSwitches: 3,
                        labels: ['Todo', 'Skipped', 'Packed'],
                        onToggle: (index) {
                          widget.item.state = switch (index) {
                            0 => PackingListItemStateEnum.todo,
                            1 => PackingListItemStateEnum.skipped,
                            2 => PackingListItemStateEnum.packed,
                            _ => PackingListItemStateEnum.todo
                          };
                          //print('switched to: $index');
                          saveAndClose();
                        },
                      ))),
                  Row(children: [
                    Spacer(),
                    if (widget.orgItem != null)
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
                              widget.onItemDeleted(widget.item);
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
                            saveAndClose();
                          }),
                    ),
                  ]),
                  TextField(
                    controller: TextEditingController()
                      ..text = widget.item.comment,
                    decoration: const InputDecoration(hintText: 'Comment'),
                    onChanged: (value) => widget.item.comment = value,
                    keyboardType: TextInputType.multiline,
                    minLines: 10, //Normal textInputField will be displayed
                    maxLines: 10, // when user presses enter it will adapt to it
                  )
                ])));
  }
}
