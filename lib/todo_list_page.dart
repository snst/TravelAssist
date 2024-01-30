import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'todo_list_item_widget.dart';
import 'todo_item_page.dart';
import 'todo_item.dart';
import 'todo_provider.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage(
      {super.key, required this.title, required this.createDrawer});
  final String title;
  final Drawer Function(BuildContext context) createDrawer;
  @override
  State<TodoListPage> createState() => _PackingListPageState();
}

class _PackingListPageState extends State<TodoListPage> {
  bool _listEditable = false;
  int _selectedFilterIndex = 1;

  TodoItemStateEnum bottomIndexToStateEnum(int index) {
    final filters = [
      TodoItemStateEnum.done,
      TodoItemStateEnum.open,
      TodoItemStateEnum.skipped
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
          builder: (context) => TodoItemPage(
                newItem: newItem,
                item: item,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 5,
                  child: Text(_listEditable ? "Hide check" : "Check")),
            ],
            elevation: 2,
            onSelected: (value) {
              switch (value) {
                case 5:
                  toggleEdit();
                  break;
              }
            },
          ),
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoList, child) {
          return GroupedListView<TodoItem, String>(
            elements: todoList
                .getFilteredItems(bottomIndexToStateEnum(_selectedFilterIndex)),
            groupBy: (TodoItem element) => element.category,
            groupComparator: (value1, value2) => value2.compareTo(value1),
            itemComparator: (TodoItem element1, TodoItem element2) =>
                element1.name.compareTo(element2.name),
            order: GroupedListOrder.DESC,
            useStickyGroupSeparators: false,
            groupSeparatorBuilder: (String value) => Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: Container(
                color: Colors.grey.shade900,
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                    )),
              ),
            ),
            itemBuilder: (context, item) => TodoListItemWidget(
                item: item,
                onItemChanged: (item) {
                  setState(() {});
                },
                onEditItem: (item) => _showEditDialog(item, false),
                editable: _listEditable),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.squareCheck),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.square),
            label: 'Open',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.ban),
            label: 'Skipped',
          ),
        ],
        currentIndex: _selectedFilterIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          setState(() {
            _selectedFilterIndex = index;
          });
        },
      ),
      drawer: widget.createDrawer(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditDialog(TodoItem(quantity: 1), false),
        tooltip: 'Add item',
        child: const Icon(Icons.add),
      ),
    );
  }
}