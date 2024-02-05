import 'dart:convert';

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
    addList([item]);
  }

  void addList(List<TodoItem> items) async {
    final isar = await db;
    await isar!.writeTxn(() async {
      for (final item in items) {
        await isar.todoItems.put(item);
        if (!_items.contains(item)) {
          _items.add(item);
        }
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

  void clear() async {
    final isar = await db;
    await isar!.writeTxn(() async {
      await isar.todoItems.clear();
      _items.clear();
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

  String toJson() {
    List<Map<String, dynamic>> jsonList =
        _items.map((item) => item.toJson()).toList();
    return jsonEncode(jsonList);
  }

  void fromJson(String? jsonString) {
    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);
      List<TodoItem> newItems =
          jsonList.map((json) => TodoItem.fromJson(json)).toList();
      clear();
      addList(newItems);
    }
  }
}
