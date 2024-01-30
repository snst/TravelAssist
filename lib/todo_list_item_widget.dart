import 'package:flutter/material.dart';
import 'todo_item.dart';

class TodoListItemWidget extends StatelessWidget {
  TodoListItemWidget(
      {required this.item,
      required this.onItemChanged,
      required this.onEditItem,
      required this.editable})
      : super(key: ObjectKey(item));

  final TodoItem item;
  final void Function(TodoItem item) onItemChanged;
  final void Function(TodoItem item) onEditItem;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: editable ? 45 : 25,
        child: ListTile(
          onTap: () {
            onEditItem(item);
          },
          minVerticalPadding: 0,
          visualDensity: const VisualDensity(vertical: -4),

          //leading: Icon(CategoryIcons[item.categoryItem]),
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    item.name,
                    //style: _getTextStyle(item.state)
                  ),
                ),
                Text('${item.quantity} / ${item.used}'),
                if (editable) ...[
                  IconButton(
                    //iconSize: 30,
                    icon: const Icon(
                      Icons.hide_source,
                      //color: Colors.red,
                    ),
                    alignment: Alignment.centerRight,
                    onPressed: () {
                      item.state = TodoItemStateEnum.skipped;
                      onItemChanged(item);
                    },
                  ),
                  Checkbox(
                    //checkColor: Colors.greenAccent,
                    //activeColor: Colors.red,
                    value: item.state == TodoItemStateEnum.done,
                    onChanged: (value) {
                      item.state = switch (item.state) {
                        TodoItemStateEnum.open =>
                          TodoItemStateEnum.done,
                        _ => TodoItemStateEnum.open
                      };
                      onItemChanged(item);
                    },
                  )
                ],
              ]),
        ));
  }
}
