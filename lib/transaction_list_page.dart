import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/budgetitem_widget.dart';
import 'package:travel_assist/currency.dart';
import 'package:travel_assist/currency_provider.dart';
import 'package:travel_assist/transaction_provider.dart';
import 'package:travel_assist/budgetitem_page.dart';
import 'package:travel_assist/transaction.dart';
import 'currency_widget.dart';

class TransactionListPage extends StatefulWidget {
  TransactionListPage({super.key, required this.createDrawer});
  final Drawer Function(BuildContext context) createDrawer;
  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
  Currency? shownCurrency = null;
}

class _TransactionListPageState extends State<TransactionListPage> {

  Future<void> _showEditDialog(Transaction item) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BudgetItemPage(
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

  Widget _getItem(BuildContext ctx, Transaction item) {
    return BudgetListItemWidget(
      item: item,
      onEditItem: _showEditDialog,
    );
  }
*/

  @override
  Widget build(BuildContext context) {
    //final cp = CurrencyProvider.getInstance(context);
    //final tp = TransactionProvider.getInstance(context);
    final cp = context.watch<CurrencyProvider>();
    final tp = context.watch<TransactionProvider>();
    tp.initCurrencies(cp);
    widget.shownCurrency ??= cp.getHomeCurrency();

    var res = tp.calculate(widget.shownCurrency!, null);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Text(Currency.formatValue(res.sumExpense)),
          CurrencyWidget(
              currencies: cp.items,
              selected: widget.shownCurrency!,
              onChanged: (currency) { setState(() {
                widget.shownCurrency = currency;
              });})
        ],
        title: const Text("Expenses"),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, transactions, child) {
          return GroupedListView<Transaction, DateTime>(
              elements: transactions.getSortedTransactions(null),
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
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
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
          final currency =
              CurrencyProvider.getInstance(context).getCurrencyByName('\$');
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BudgetItemPage(
                      newItem: true,
                      item: Transaction(
                          date: DateTime.now(),
                          currencyKey: currency.id,
                          currency: currency),
                    )),
          );
        },
        tooltip: 'Add item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
