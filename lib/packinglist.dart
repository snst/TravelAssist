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
class PackingListItem extends HiveObject {
  PackingListItem(
      {this.name = "",
      this.quantity = 0,
      this.used = 0,
      this.state = PackingListItemStateEnum.missing,
      this.category = "",
      this.comment = ""});

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

  PackingListItem clone() {
    return PackingListItem(
        name: name,
        quantity: quantity,
        used: used,
        state: state,
        category: category,
        comment: comment);
  }

  PackingListItem.copy(PackingListItem other)
      : name = other.name,
        state = other.state,
        quantity = other.quantity,
        used = other.used,
        category = other.category,
        comment = other.comment;

  void update(PackingListItem other) {
    name = other.name;
    quantity = other.quantity;
    used = other.used;
    state = other.state;
    category = other.category;
    comment = other.comment;
  }
}

class PackingList extends ChangeNotifier {
  PackingList(this._name);

  bool _loaded = false;
  String _name;
  Box<PackingListItem>? _box;

  String get hiveName => 'packinglist_${_name}';
  List<PackingListItem> get items => _box != null ? _box!.values.toList() : [];

  void load() async {
    if (!_loaded) {
      _box = await Hive.openBox(hiveName);
      _loaded = true;
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
    _box?.add( item);
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
