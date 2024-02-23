import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_assist/drawer_widget.dart';
import 'package:travel_assist/export_widget.dart';
import 'todo_list_widget.dart';
import 'todo_item_edit_page.dart';
import 'todo_item.dart';
import 'todo_provider.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key, required this.drawer});
  static int pageIndex = 2;
  final DrawerWidget drawer;
  @override
  State<TodoListPage> createState() => _PackingListPageState();
}

class _PackingListPageState extends State<TodoListPage> {
  bool _listEditable = false;
  int _selectedFilterIndex = 1;
  int _selectedBottomIndex = 1;

  TodoItemStateEnum bottomIndexToStateEnum(int index) {
    final filters = [
      TodoItemStateEnum.skipped,
      TodoItemStateEnum.open,
      TodoItemStateEnum.done,
    ];
    return filters[index];
  }

  void toggleEdit() {
    _listEditable = !_listEditable;
    setState(() {});
  }

  Future<void> _showEditDialog(TodoItem item, bool newItem) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TodoItemEditPage(
                newItem: newItem,
                item: item,
              )),
    );
  }

  void showTodoSettingsPage(BuildContext context, TodoProvider todoProvider) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Settings"),
          ),
          body: ExportWidget(
            name: 'todo',
            toJson: todoProvider.toJson,
            fromJson: todoProvider.fromJson,
            clearJson: todoProvider.clear,
          ));
    }));
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.watch<TodoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("To-do"),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              const PopupMenuItem(value: 1, child: Text("Quick edit")),
              const PopupMenuItem(value: 2, child: Text("Settings")),
            ],
            elevation: 2,
            onSelected: (value) {
              switch (value) {
                case 1:
                  toggleEdit();
                  break;
                case 2:
                  showTodoSettingsPage(context, todoProvider);
                  break;
              }
            },
          ),
        ],
      ),
      body: GroupedListView<TodoItem, String>(
        elements: todoProvider
            .getFilteredItems(bottomIndexToStateEnum(_selectedFilterIndex)),
        groupBy: (TodoItem element) => element.category,
        groupComparator: (value1, value2) => value2.compareTo(value1),
        itemComparator: (TodoItem element1, TodoItem element2) =>
            element1.name.compareTo(element2.name),
        order: GroupedListOrder.DESC,
        useStickyGroupSeparators: false,
        groupSeparatorBuilder: (String value) => Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
          child: Align(
              alignment: Alignment.center,
              child: Text(
                value,
                textAlign: TextAlign.center,
              )),
        ),
        itemBuilder: (context, item) => TodoListWidget(
            item: item,
            onItemChanged: (item) {
              setState(() {});
            },
            onEditItem: (item) => _showEditDialog(item, false),
            editable: _listEditable,
            filterIndex: bottomIndexToStateEnum(_selectedFilterIndex)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.ban),
            label: 'Skipped',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.square),
            label: 'Open',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.squareCheck),
            label: 'Done',
          ),
        ],
        currentIndex: _selectedBottomIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedBottomIndex = index;
            if (index <= 2) {
              _selectedFilterIndex = index;
            }
          });
        },
      ),
      drawer: widget.drawer,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditDialog(TodoItem(quantity: 1), true),
        tooltip: 'Add item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
