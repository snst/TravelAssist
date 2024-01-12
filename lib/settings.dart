/*
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'packinglist.dart'
part 'settings.g.dart';

@HiveType(typeId: 0)
class Settings extends ChangeNotifier {
  
  @HiveField(0)
  List<String> _todoListNames = [];
  bool _loaded = false;
  final String _name = 'settings';

  void load() {
    if (!_loaded) {
      final PackingList pl = Hive.box(_name)
          .get(_name, defaultValue: Settings());
      _loaded = true;
      update(pl);
    }
  }

  void save() {
    Hive.box(_name).put(_name, this);
  }
}

*/