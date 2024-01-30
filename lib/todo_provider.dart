import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'storage.dart';
import 'todo_item.dart';

class TodoProvider extends ChangeNotifier with Storage {
  TodoProvider() {
    db = openDB();
    init();
  }

  List<TodoItem> _items = [];
  List<TodoItem> get items => _items;

  void init() async {
    final isar = await db;
    isar!.txn(() async {
      _items = await isar.todoItems.where().findAll();
      notifyListeners();
    });
  }

  static TodoProvider getInstance(BuildContext context) {
    return Provider.of<TodoProvider>(context, listen: false);
  }

  List<String> getCategories() {
    List<String> ret = [];
    for (final item in items) {
      if (!ret.contains(item.category)) {
        ret.add(item.category);
      }
    }
    ret.sort();
    return ret;
  }

  void add(TodoItem item) async {
    final isar = await db;
    await isar!.writeTxn(() async {
      await isar.todoItems.put(item);
      if (!_items.contains(item)) {
        _items.add(item);
      }
      notifyListeners();
    });
  }

  void delete(TodoItem item) async {
    final isar = await db;
    await isar!.writeTxn(() async {
      await isar.todoItems.delete(item.id);
      _items.remove(item);
      notifyListeners();
    });
  }

  List<TodoItem> getFilteredItems(TodoItemStateEnum state) {
    switch (state) {
      case TodoItemStateEnum.done:
        return items.where((i) => i.state == TodoItemStateEnum.done).toList();
      case TodoItemStateEnum.skipped:
        return items
            .where((i) => i.state == TodoItemStateEnum.skipped)
            .toList();
      case TodoItemStateEnum.open:
        return items.where((i) => i.state == TodoItemStateEnum.open).toList();
    }
  }
}
