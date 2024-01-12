import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'packinglist.dart';
import 'packingitem_widget.dart';
import 'packingitem_page.dart';

class PackingListPage extends StatefulWidget {
  const PackingListPage(
      {super.key, required this.title, required this.createDrawer});
  final String title;
  final Drawer Function(BuildContext context) createDrawer;
  @override
  State<PackingListPage> createState() => _PackingListPageState();
}

class _PackingListPageState extends State<PackingListPage> {
  //final PackingList _packingList =
  //    Hive.box('packinglist').get('1', defaultValue: PackingList("default"));
  bool _listEditable = false;
  int _selectedFilterIndex = 1;

  void saveData() {
    //Hive.box('packinglist').put('1', _packingList);
  }

  PackingListItemStateEnum bottomIndexToStateEnum(int index) {
    final filters = [
      PackingListItemStateEnum.packed,
      PackingListItemStateEnum.missing,
      PackingListItemStateEnum.skipped
    ];
    return filters[index];
  }

  void toggleEdit() {
    _listEditable = !_listEditable;
    setState(() {});
  }

  Future<void> _showEditDialog(PackingListItem item) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => /*const*/ PackedItemPage(
                newItem: false,
                item: item,
              )),
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
      body: Consumer<PackingList>(
        builder: (context, packinglist, child) {
          packinglist.load();
          return
              /*
          StickyGroupedListView<PackingListItem, String>(
            elements: packinglist.getFilteredItems(bottomIndexToStateEnum(_selectedFilterIndex)),
       //     elements: packinglist.items,
            order: StickyGroupedListOrder.ASC,
            groupBy: (PackingListItem element) => element.category,
            groupComparator: (String value1, String value2) =>
                value2.compareTo(value1),
            itemComparator:
                (PackingListItem element1, PackingListItem element2) =>
                    element1.name.compareTo(element2.name),
            floatingHeader: true,
            groupSeparatorBuilder: _getGroupSeparator,
            */
              GroupedListView<PackingListItem, String>(
            elements: packinglist
                .getFilteredItems(bottomIndexToStateEnum(_selectedFilterIndex)),
            groupBy: (PackingListItem element) => element.category,
            groupComparator: (value1, value2) => value2.compareTo(value1),
            itemComparator:
                (PackingListItem element1, PackingListItem element2) =>
                    element1.name.compareTo(element2.name),
            order: GroupedListOrder.DESC,
            useStickyGroupSeparators: false,
            groupSeparatorBuilder: (String value) => SizedBox(
              height: 50,
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: double.infinity,
                  child: Card(
                      color: Colors.grey.shade900,
                      child: Text(
                        value,
                        textAlign: TextAlign.center,
                      )),
                ),
              ),
            ),
            itemBuilder: _getItem,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.squareCheck),
            label: 'Packed',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.square),
            label: 'Missing',
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => /*const*/ PackedItemPage(
                      newItem: true,
                      item: PackingListItem(quantity: 1),
                    )),
          );
        },
        tooltip: 'Add item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
