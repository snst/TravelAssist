import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'todo_item.dart';

class TodoListWidget extends StatelessWidget {
  const TodoListWidget(
      {super.key,
      required this.item,
      required this.onItemChanged,
      required this.onEditItem,
      required this.editable,
      required this.filterIndex});

  final TodoItem item;
  final void Function(TodoItem item) onItemChanged;
  final void Function(TodoItem item) onEditItem;
  final bool editable;
  final TodoItemStateEnum filterIndex;

  void setState(TodoItemStateEnum state) {
    item.state = state;
    onItemChanged(item);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      onTap: () {
        onEditItem(item);
      },
      minVerticalPadding: 0,
      visualDensity: const VisualDensity(vertical: -4),
      title: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Text(
                item.name,
              ),
            ),
            Text('${item.quantity} / ${item.used}'),
            if (editable && filterIndex != TodoItemStateEnum.skipped) ...[
              IconButton(
                iconSize: 24,
                icon: const FaIcon(FontAwesomeIcons.ban),
                onPressed: () => setState(TodoItemStateEnum.skipped),
              ),
            ],
            if (editable && filterIndex != TodoItemStateEnum.open) ...[
              IconButton(
                iconSize: 24,
                icon: const FaIcon(FontAwesomeIcons.square),
                onPressed: () => setState(TodoItemStateEnum.open),
              ),
            ],
            if (editable && filterIndex != TodoItemStateEnum.done) ...[
              IconButton(
                iconSize: 24,
                icon: const FaIcon(FontAwesomeIcons.squareCheck),
                onPressed: () => setState(TodoItemStateEnum.done),
              ),
            ],
          ]),
    ));
  }
}
