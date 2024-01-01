import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

//import 'package:path_provider/path_provider.dart';
//import 'package:flutter/services.dart';
//import 'package:flutter_spinbox/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'packinglist.dart';
import 'packing_list_item_widget.dart';
import 'packinglist_page.dart';

void main() async {
  Hive.registerAdapter(PackingListItemStateFilterEnumAdapter());
  Hive.registerAdapter(PackingListItemStateEnumAdapter());
  Hive.registerAdapter(PackingListItemAdapter());
  Hive.registerAdapter(PackingListAdapter());

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('packinglist');

  runApp(const MyApp());
}

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
  final PackingList _packingList =
      Hive.box('packinglist').get('1', defaultValue: PackingList("default"));
  //PackingListItemStateFilterEnum _packingListFilter = Hive.box('settings')
  //    .get('packingListFilter', defaultValue: PackingListItemStateFilterEnum.all);
  bool _listEditable = false;

  void saveData() {
    Hive.box('packinglist').put('1', _packingList);
  }

  List<PackingListItem> filterPackingList() {
    switch (_packingList.stateFilter) {
      case PackingListItemStateFilterEnum.all:
        return _packingList.items;
      case PackingListItemStateFilterEnum.packed:
        return _packingList.items
            .where((i) => i.state == PackingListItemStateEnum.packed)
            .toList();
      case PackingListItemStateFilterEnum.skipped:
        return _packingList.items
            .where((i) => i.state == PackingListItemStateEnum.skipped)
            .toList();
      case PackingListItemStateFilterEnum.missing:
        return _packingList.items
            .where((i) => i.state == PackingListItemStateEnum.missing)
            .toList();
    }
  }

  void _handlePackingListItemUpdate(
      PackingListItem? oldItem, PackingListItem newItem) {
    _packingList.items[_packingList.items
        .indexWhere((element) => element == oldItem)] = newItem;
    saveData();
    setState(() {});
  }

  void setPackingListFilter(PackingListItemStateFilterEnum filter) {
    _packingList.stateFilter = filter;
    saveData();
    setState(() {});
  }

  void _handlePackingListItemDelete(PackingListItem item) {
    _packingList.items.removeWhere((element) => element.name == item.name);
    saveData();
    setState(() {});
  }

  void _handlePackingListItemAdd(PackingListItem item) {
    _packingList.items.add(item);
    saveData();
    setState(() {});
  }

  void toggleEdit() {
    _listEditable = !_listEditable;
    setState(() {});
  }

  List<String> getCategories() {
    List<String> ret = [];
    for (final item in _packingList.items) {
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
              onItemModified: _handlePackingListItemUpdate,
              onItemAdded: _handlePackingListItemAdd,
              onItemDeleted: _handlePackingListItemDelete)),
    );
  }

  Widget _getGroupSeparator(PackingListItem element) {
    return SizedBox(
      height: 50,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: double.infinity,
          child: Card(
              color: Colors.grey.shade900,
              child: Text(
                element.category,
                textAlign: TextAlign.center,
              )),
        ),
      ),
    );
  }

  Widget _getItem(BuildContext ctx, PackingListItem item) {
    return PackingListItemWidget(
        item: item,
        onItemChanged: (item) {
          setState(() {});
        },
        onEditItem: _showEditDialog,
        editable: _listEditable);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              if (_packingList.stateFilter !=
                  PackingListItemStateFilterEnum.all)
                const PopupMenuItem(value: 1, child: Text("Show all")),
              if (_packingList.stateFilter !=
                  PackingListItemStateFilterEnum.skipped)
                const PopupMenuItem(value: 2, child: Text("Show skipped")),
              if (_packingList.stateFilter !=
                  PackingListItemStateFilterEnum.packed)
                const PopupMenuItem(value: 3, child: Text("Show packed")),
              if (_packingList.stateFilter !=
                  PackingListItemStateFilterEnum.missing)
                const PopupMenuItem(value: 4, child: Text("Show missing")),
              PopupMenuItem(
                  value: 5,
                  child: Text(_listEditable ? "Hide check" : "Check")),
            ],
            elevation: 2,
            onSelected: (value) {
              switch (value) {
                case 1:
                  setPackingListFilter(PackingListItemStateFilterEnum.all);
                  break;
                case 2:
                  setPackingListFilter(PackingListItemStateFilterEnum.skipped);
                  break;
                case 3:
                  setPackingListFilter(PackingListItemStateFilterEnum.packed);
                  break;
                case 4:
                  setPackingListFilter(PackingListItemStateFilterEnum.missing);
                  break;
                case 5:
                  toggleEdit();
                  break;
              }
            },
          ),
        ],
      ),
      body: StickyGroupedListView<PackingListItem, String>(
        elements: filterPackingList(),
        order: StickyGroupedListOrder.ASC,
        groupBy: (PackingListItem element) => element.category,
        groupComparator: (String value1, String value2) =>
            value2.compareTo(value1),
        itemComparator: (PackingListItem element1, PackingListItem element2) =>
            element1.name.compareTo(element2.name),
        floatingHeader: true,
        groupSeparatorBuilder: _getGroupSeparator,
        itemBuilder: _getItem,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => /*const*/ PackedItemPage(
                    title: 'Add item',
                    orgItem: null,
                    item: PackingListItem(quantity: 1),
                    categories: getCategories(),
                    onItemModified: _handlePackingListItemUpdate,
                    onItemAdded: _handlePackingListItemAdd,
                    onItemDeleted: _handlePackingListItemDelete)),
          );
        },
        tooltip: 'Add item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
