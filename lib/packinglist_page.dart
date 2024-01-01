import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'packinglist.dart';

class PackedItemPage extends StatefulWidget {
  const PackedItemPage(
      {super.key,
      required this.title,
      required this.orgItem,
      required this.item,
      required this.categories,
      required this.onItemModified,
      required this.onItemAdded,
      required this.onItemDeleted});

  final String title;
  final PackingListItem item;
  final PackingListItem? orgItem;
  final List<String> categories;
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
    final TextEditingController controller = TextEditingController();
    controller.text = widget.item.category;

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
                  TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(
                          hintText: 'Category',
                          suffixIcon: IconButton(
                            onPressed: controller.clear,
                            icon: const Icon(Icons.clear),
                          )),
                      controller: controller, //TextEditingController()
                      //..text = widget.item.category,
                    ),
                    suggestionsCallback: (pattern) {
                      widget.item.category = pattern;
                      List<String> strlist = widget.categories
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
                        widget.item.category = suggestion;
                      });
                    },
                  ),
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                      child: SpinBox(
                        value: widget.item.quantity.toDouble(),
                        decoration: const InputDecoration(
                            constraints: BoxConstraints.tightFor(
                              width: 150,
                            ),
                            labelText: 'Quantity'),
                        onChanged: (value) =>
                            widget.item.quantity = value.toInt(),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                      child: SpinBox(
                        value: widget.item.used.toDouble(),
                        decoration: const InputDecoration(
                            constraints: BoxConstraints.tightFor(
                              width: 150,
                            ),
                            labelText: 'Used'),
                        onChanged: (value) => widget.item.used = value.toInt(),
                      ),
                    )
                  ]),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
                      child: Center(
                          child: ToggleSwitch(
                        initialLabelIndex: switch (widget.item.state) {
                          PackingListItemStateEnum.missing => 0,
                          PackingListItemStateEnum.skipped => 1,
                          PackingListItemStateEnum.packed => 2
                        },
                        totalSwitches: 3,
                        labels: const ['Missing', 'Skipped', 'Packed'],
                        onToggle: (index) {
                          widget.item.state = switch (index) {
                            0 => PackingListItemStateEnum.missing,
                            1 => PackingListItemStateEnum.skipped,
                            2 => PackingListItemStateEnum.packed,
                            _ => PackingListItemStateEnum.missing
                          };
                          //print('switched to: $index');
                          saveAndClose();
                        },
                      ))),
                  Row(children: [
                    const Spacer(),
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
