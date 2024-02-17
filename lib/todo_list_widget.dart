import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'todo_item.dart';

class TodoListWidget extends StatelessWidget {
  const TodoListWidget(
      {super.key,
      required this.item,
      required this.onItemChanged,
      required this.onEditItem,
      required this.editable});

  final TodoItem item;
  final void Function(TodoItem item) onItemChanged;
  final void Function(TodoItem item) onEditItem;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    final List<bool> _toggleButtonsSelection = [true, false, true];
    return Card(
        //height: editable ? 45 : 45,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                child: ToggleButtons(
                    // ToggleButtons uses a List<bool> to track its selection state.
                    isSelected: [
                      item.state == TodoItemStateEnum.skipped,
                      item.state == TodoItemStateEnum.open,
                      item.state == TodoItemStateEnum.done
                    ],
                    // This callback return the index of the child that was pressed.
                    onPressed: (int index) {
                      item.state = switch (index) {
                        0 => TodoItemStateEnum.skipped,
                        1 => TodoItemStateEnum.open,
                        _ => TodoItemStateEnum.done
                      };
                      onItemChanged(item);
                      //  setState(() {
                      //  _toggleButtonsSelection[index] =
                      // (())    !_toggleButtonsSelection[index];
                      //});
                    },
                    // Constraints are used to determine the size of each child widget.
                    /* constraints: const BoxConstraints(
                minHeight: 32.0,
                minWidth: 56.0,
                            ),*/
                    children: [
                      FaIcon(FontAwesomeIcons.ban),
                      FaIcon(FontAwesomeIcons.square),
                      FaIcon(FontAwesomeIcons.squareCheck)
                    ]),
              ),
              /*
                  SegmentedButton<TodoItemStateEnum>(
                    showSelectedIcon: false,
                    segments: const <ButtonSegment<TodoItemStateEnum>>[
                      ButtonSegment<TodoItemStateEnum>(
                          value: TodoItemStateEnum.open,
                          icon: FaIcon(FontAwesomeIcons.square)),
                      ButtonSegment<TodoItemStateEnum>(
                          value: TodoItemStateEnum.skipped,
                          icon: FaIcon(FontAwesomeIcons.ban)),
                      ButtonSegment<TodoItemStateEnum>(
                          value: TodoItemStateEnum.done,
                          icon: FaIcon(FontAwesomeIcons.squareCheck)),
                    ],
                    selected: <TodoItemStateEnum>{item.state},
                    onSelectionChanged:
                        (Set<TodoItemStateEnum> newSelection) {
                          item.state = newSelection.first;
                      onItemChanged(
                          item); /*
                      setState(() {
                        widget.modifiedItem.state = newSelection.first;
                      });*/
                    },
                  ),
*/ /*
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
                        TodoItemStateEnum.open => TodoItemStateEnum.done,
                        _ => TodoItemStateEnum.open
                      };
                      onItemChanged(item);
                    },
                  )
                  */
            ],
          ]),
    ));
  }
}
