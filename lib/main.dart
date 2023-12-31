import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:flutter_spinbox/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'packing_list_item.dart';
import 'packing_list_item_widget.dart';
//import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'packing_item_page.dart';

void main() {
  runApp(const MyApp());
}

enum FilterPackingListEnum { all, skipped, todo, packed }


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TravelApp',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: const PackingListPage(title: 'TravelApp'),
    );
  }
}

class PackingListPage extends StatefulWidget {
  const PackingListPage({super.key, required this.title});
  final String title;
  @override
  State<PackingListPage> createState() => _PackingListPageState();
}

class _PackingListPageState extends State<PackingListPage> {
  final List<PackingListItem> _packingList = <PackingListItem>[];
  FilterPackingListEnum _packingListFilter = FilterPackingListEnum.all;
  bool _listEditable = false;

/*
  List<IconData> _categoryIcons = [
    FontAwesomeIcons.shirt,
    FontAwesomeIcons.socks,
    FontAwesomeIcons.suitcaseMedical,
    FontAwesomeIcons.headphones,
    FontAwesomeIcons.cookieBite,
    FontAwesomeIcons.creditCard,
    FontAwesomeIcons.book,
    FontAwesomeIcons.volleyball,
    FontAwesomeIcons.binoculars,
    FontAwesomeIcons.pumpSoap,
  ];*/

  void _handlePackingListItemUpdate(
      PackingListItem? oldItem, PackingListItem newItem) {
    setState(() {
      //addCategory(newItem.category);
      _packingList[_packingList.indexWhere((element) => element == oldItem)] =
          newItem;
    });
  }

  List<PackingListItem> filterPackingList() {
    switch (_packingListFilter) {
      case FilterPackingListEnum.all:
        return _packingList;
      case FilterPackingListEnum.packed:
        return _packingList
            .where((i) => i.state == PackingListItemStateEnum.packed)
            .toList();
      case FilterPackingListEnum.skipped:
        return _packingList
            .where((i) => i.state == PackingListItemStateEnum.skipped)
            .toList();
      case FilterPackingListEnum.todo:
        return _packingList
            .where((i) => i.state == PackingListItemStateEnum.todo)
            .toList();
    }
  }

  void setPackingListFilter(FilterPackingListEnum filter) {
    _packingListFilter = filter;
    setState(() {});
  }

  void _handlePackingListItemDelete(PackingListItem item) {
    setState(() {
      _packingList.removeWhere((element) => element.name == item.name);
    });
  }

  //void addCategory(String category) {
  //if (!_categories.contains(category)) {
  //  _categories.insert(0, category);
  //}
  //}

  void _handlePackingListItemAdd(PackingListItem item) {
    setState(() {
      _packingList.add(item);
      //addCategory(item.category);
    });
  }

  void toggleEdit() {
    setState(() {
      _listEditable = !_listEditable;
    });
  }

  List<String> getCategories() {
    List<String> ret = [];
    for (final item in _packingList) {
      if (!ret.contains(item.category)) {
        ret.add(item.category);
      }
    }
    ret.sort();
    return ret;
  }

  Future<void> _showEditDialog(PackingListItem item) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => /*const*/ PackedItemPage(
              title: 'Edit item',
              orgItem: item,
              item: item.clone(),
              categories: getCategories(),
              //categoryItems: _categoryIcons,
              onItemModified: _handlePackingListItemUpdate,
              onItemAdded: _handlePackingListItemAdd,
              onItemDeleted: _handlePackingListItemDelete)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              if (_packingListFilter != FilterPackingListEnum.all)
                PopupMenuItem(value: 1, child: Text("Show all")),
              if (_packingListFilter != FilterPackingListEnum.skipped)
                PopupMenuItem(value: 2, child: Text("Show skipped")),
              if (_packingListFilter != FilterPackingListEnum.packed)
                PopupMenuItem(value: 3, child: Text("Show packed")),
              if (_packingListFilter != FilterPackingListEnum.todo)
                PopupMenuItem(value: 4, child: Text("Show todo")),
              PopupMenuItem(
                  value: 5,
                  child: Text(_listEditable ? "No edit" : "Fast edit")),
            ],
            //offset: Offset(0, 100),
            //color: Colors.grey,
            elevation: 2,
            onSelected: (value) {
              switch (value) {
                case 1:
                  setPackingListFilter(FilterPackingListEnum.all);
                  break;
                case 2:
                  setPackingListFilter(FilterPackingListEnum.skipped);
                  break;
                case 3:
                  setPackingListFilter(FilterPackingListEnum.packed);
                  break;
                case 4:
                  setPackingListFilter(FilterPackingListEnum.todo);
                  break;
                case 5:
                  toggleEdit();
                  break;
              }
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: filterPackingList().map((PackingListItem item) {
          return PackingListItemWidget(
              item: item,
              onItemChanged: (item) {
                setState(() {});
              },
              onEditItem: _showEditDialog,
              editable: _listEditable);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        //onPressed: _showAddDialog,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => /*const*/ PackedItemPage(
                    title: 'Add item',
                    orgItem: null,
                    item: PackingListItem(quantity: 1),
                    categories: getCategories(),
                    //categoryItems: _categoryIcons,
                    onItemModified: _handlePackingListItemUpdate,
                    onItemAdded: _handlePackingListItemAdd,
                    onItemDeleted: _handlePackingListItemDelete)),
          );
        },
        tooltip: 'Add item',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
