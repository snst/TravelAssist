

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'packinglist.dart';

class PackingListModel extends ChangeNotifier {
  PackingListModel(this._name);

  String _name;
  Box<PackingListItem>? _box;

  String get hiveName => 'packinglist_${_name}';
  List<PackingListItem> get items => _box != null ? _box!.values.toList() : [];

  void load() async {
    if (_box == null) {
      _box = await Hive.openBox(hiveName);
      notifyListeners();
    }
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

  void notifyItemChanged(PackingListItem item) {
    _box?.delete(item.key);
    _box?.add(item);
    notifyListeners();
  }

  void deleteItem(PackingListItem item) {
    _box?.delete(item.key);
    notifyListeners();
  }

  void addItem(PackingListItem item) {
    _box?.add(item);
    notifyListeners();
  }

  //int cntItem() => _items.length;
  //PackingListItem getItem(int i) => _items.elementAt(i);

  List<PackingListItem> getFilteredItems(PackingListItemStateEnum state) {
    switch (state) {
      case PackingListItemStateEnum.packed:
        return items
            .where((i) => i.state == PackingListItemStateEnum.packed)
            .toList();
      case PackingListItemStateEnum.skipped:
        return items
            .where((i) => i.state == PackingListItemStateEnum.skipped)
            .toList();
      case PackingListItemStateEnum.missing:
        return items
            .where((i) => i.state == PackingListItemStateEnum.missing)
            .toList();
    }
  }
}
