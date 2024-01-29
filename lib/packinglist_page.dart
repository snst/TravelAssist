import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'packinglist.dart';
import 'packingitem_widget.dart';
import 'packingitem_page.dart';
import 'packinglist_model.dart';

class PackingListPage extends StatefulWidget {
  const PackingListPage(
      {super.key, required this.title, required this.createDrawer});
  final String title;
  final Drawer Function(BuildContext context) createDrawer;
  @override
  State<PackingListPage> createState() => _PackingListPageState();
}

class _PackingListPageState extends State<PackingListPage> {
  bool _listEditable = false;
  int _selectedFilterIndex = 1;

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
      body: Consumer<PackingListModel>(
        builder: (context, packinglist, child) {
          packinglist.load();
          return GroupedListView<PackingListItem, String>(
            elements: packinglist
                .getFilteredItems(bottomIndexToStateEnum(_selectedFilterIndex)),
            groupBy: (PackingListItem element) => element.category,
            groupComparator: (value1, value2) => value2.compareTo(value1),
            itemComparator:
                (PackingListItem element1, PackingListItem element2) =>
                    element1.name.compareTo(element2.name),
            order: GroupedListOrder.DESC,
            useStickyGroupSeparators: false,
            groupSeparatorBuilder: (String value) => Padding(
              padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
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
            itemBuilder: (context, item) => PackingListItemWidget(
                item: item,
                onItemChanged: (item) {
                  setState(() {});
                },
                onEditItem: _showEditDialog,
                editable: _listEditable),
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
