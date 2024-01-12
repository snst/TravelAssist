import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'packinglist.g.dart';

@HiveType(typeId: 1)
enum PackingListItemStateEnum {
  @HiveField(0)
  missing,
  @HiveField(1)
  skipped,
  @HiveField(2)
  packed;
}

@HiveType(typeId: 2)
class PackingListItem {
  PackingListItem(
      {this.name = "",
      this.quantity = 0,
      this.used = 0,
      this.state = PackingListItemStateEnum.missing,
      this.category = "",
      this.comment = "",
      this.id = 0}) {
    assignNextId();
  }

  @HiveField(0)
  String name;
  @HiveField(1)
  String category;
  @HiveField(2)
  String comment;
  @HiveField(3)
  int quantity;
  @HiveField(4)
  int used;
  @HiveField(5)
  PackingListItemStateEnum state;
  @HiveField(6)
  int id;

  static int nextid = 0;

  void assignNextId() {
    id = PackingListItem.nextid++;
  }

  PackingListItem clone() {
    return PackingListItem(
        name: name,
        quantity: quantity,
        used: used,
        state: state,
        category: category,
        comment: comment,
        id: id);
  }

  PackingListItem.copy(PackingListItem other)
      : name = other.name,
        state = other.state,
        quantity = other.quantity,
        used = other.used,
        category = other.category,
        comment = other.comment,
        id = other.id;

  void update(PackingListItem other) {
    name = other.name;
    quantity = other.quantity;
    used = other.used;
    state = other.state;
    category = other.category;
    comment = other.comment;
  }
}

@HiveType(typeId: 3)
class PackingList extends ChangeNotifier {
  PackingList(this._name);

  //UnmodifiableListView<PackingListItem> get items => UnmodifiableListView(_items);

  @HiveField(0)
  String _name;
  @HiveField(1)
  List<PackingListItem> _items = [];
  bool _loaded = false;
  final String _hiveBoxName = 'packingList2';

  void load() {
    if (!_loaded) {
      final PackingList pl = Hive.box(_hiveBoxName)
          .get(_name, defaultValue: PackingList(_name));
      _loaded = true;
      update(pl);
    }
  }

  void save() {
    Hive.box(_hiveBoxName).put(_name, this);
  }

  void update(PackingList other) {
    _name = other._name;
    _items = other._items;
    //notifyListeners();
  }

  List<String> getCategories() {
    List<String> ret = [];
    for (final item in _items) {
      if (!ret.contains(item.category)) {
        ret.add(item.category);
      }
    }
    ret.sort();
    return ret;
  }

  void notifyItemChanged() {
    save();
    notifyListeners();
  }

  void deleteItem(PackingListItem item) {
    _items.removeWhere((element) => element.id == item.id);
    notifyItemChanged();
  }

  void addItem(PackingListItem item) {
    _items.add(item);
    notifyItemChanged();
  }

  int cntItem() => _items.length;

  PackingListItem getItem(int i) => _items.elementAt(i);

  List<PackingListItem> getFilteredItems(PackingListItemStateEnum state) {
    switch (state) {
      case PackingListItemStateEnum.packed:
        return _items
            .where((i) => i.state == PackingListItemStateEnum.packed)
            .toList();
      case PackingListItemStateEnum.skipped:
        return _items
            .where((i) => i.state == PackingListItemStateEnum.skipped)
            .toList();
      case PackingListItemStateEnum.missing:
        return _items
            .where((i) => i.state == PackingListItemStateEnum.missing)
            .toList();
    }
  }
}
