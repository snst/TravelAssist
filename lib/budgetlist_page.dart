import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_assist/budgetitem_widget.dart';
import 'budgetitem_page.dart';
import 'transaction.dart';

class BudgetListPage extends StatefulWidget {
  const BudgetListPage({super.key, required this.createDrawer});
  final Drawer Function(BuildContext context) createDrawer;
  @override
  State<BudgetListPage> createState() => _BudgetListPageState();
}

class _BudgetListPageState extends State<BudgetListPage> {
  Future<void> _showEditDialog(Transaction item) async {
    
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => /*const*/ BudgetItemPage(
                newItem: false,
                item: item,
              )),
    );
  }
/*
    @override
  void initState() {
    super.initState();
  }

*/
  Widget _getItem(BuildContext ctx, Transaction item) {
    return BudgetListItemWidget(
      item: item,
      onEditItem: _showEditDialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    //Provider.of<SettingsModel>(context, listen: false).load();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Budget"),
        
      ),
      body: Consumer<BudgetModel>(
        builder: (context, budgetList, child) {
          budgetList.load(context);
          return GroupedListView<Transaction, DateTime>(
              elements: budgetList.getSortedTransactions(null),
              groupBy: (Transaction element) => element.groupDate,
              //groupComparator: (value1, value2) => value2.date.compareTo(value1.date),
              itemComparator: (Transaction element1, Transaction element2) =>
                  element1.date.compareTo(element2.date),
              order: GroupedListOrder.ASC,
              //shrinkWrap: true,
              //separator:  const Divider(
              //  height: 5,
              //),

              useStickyGroupSeparators: false,
              groupSeparatorBuilder: (DateTime value) => // SizedBox(
                  //height: 28,
                  //child: Align(
                  //alignment: Alignment.centerLeft,
                  //child: SizedBox(
                  //width: double.infinity,
                  //height: 28,
                  //child:
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Container(
                      //height: 20,
                      color: Colors.grey.shade900,
                      child: Text(
                        DateFormat('  EEEE, d MMMM y').format(value),
                        textAlign: TextAlign.left,
                      ),
                      //),
                      // ),
                      //),
                    ),
                  ),
              //itemExtent: 45.0, // Adjust this value to change the item height

              itemBuilder: (context, item) => BudgetListItemWidget(
                    item: item,
                    onEditItem: _showEditDialog,
                  ));
        },
      ),
      drawer: widget.createDrawer(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => /*const*/ BudgetItemPage(
                      newItem: true,
                      item: Transaction(),
                    )),
          );
        },
        tooltip: 'Add item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
