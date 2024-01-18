import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_assist/budgetitem_widget.dart';
import 'transaction.dart';

class BudgetListPage extends StatefulWidget {
  const BudgetListPage({super.key, required this.createDrawer});
  final Drawer Function(BuildContext context) createDrawer;
  @override
  State<BudgetListPage> createState() => _BudgetListPageState();
}

class _BudgetListPageState extends State<BudgetListPage> {
  Future<void> _showEditDialog(Transaction item) async {
    /*
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => /*const*/ PackedItemPage(
                newItem: false,
                item: item,
              )),
    );*/
  }

  Widget _getGroupSeparator(Transaction element) {
    return SizedBox(
      height: 50,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: double.infinity,
          child: Card(
              color: Colors.grey.shade900,
              child: Text(
                element.dateString,
                textAlign: TextAlign.center,
              )),
        ),
      ),
    );
  }

  Widget _getItem(BuildContext ctx, Transaction item) {
    return BudgetListItemWidget(
      item: item,
      onEditItem: _showEditDialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Budget"),
        /*
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
        ],*/
      ),
      body: Consumer<BudgetModel>(
        builder: (context, budgetList, child) {
          budgetList.load(context);
          return GroupedListView<Transaction, DateTime>(
            elements: budgetList.getSortedTransactions(null),
            groupBy: (Transaction element) => element.date,
            //groupComparator: (value1, value2) => value2.date.compareTo(value1.date),
            itemComparator: (Transaction element1, Transaction element2) =>
                element1.date.compareTo(element2.date),
            order: GroupedListOrder.ASC,
            useStickyGroupSeparators: false,
            groupSeparatorBuilder: (DateTime value) => SizedBox(
              height: 28,
              child: Align(
                //alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                    color: Colors.grey.shade900,
                    child: /*Card(
                      color: Colors.grey.shade900,
                      child: */
                        Text(
                      DateFormat('  EEEE, d MMMM y').format(value),
                      textAlign: TextAlign.left,
                      //)
                    ),
                  ),
                ),
              ),
            ),
            //itemExtent: 45.0, // Adjust this value to change the item height
            itemBuilder: _getItem,
          );
        },
      ),
      drawer: widget.createDrawer(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /*
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => /*const*/ PackedItemPage(
                      newItem: true,
                      item: PackingListItem(quantity: 1),
                    )),
          );*/
        },
        tooltip: 'Add item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
