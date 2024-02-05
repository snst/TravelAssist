import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/currency.dart';
import 'package:travel_assist/currency_provider.dart';
import 'package:travel_assist/transaction_balance_subpage.dart';
import 'package:travel_assist/transaction_list_subpage.dart';
import 'package:travel_assist/transaction_provider.dart';
import 'package:travel_assist/transaction_edit_page.dart';
import 'package:travel_assist/transaction.dart';
import 'package:travel_assist/export_widget.dart';
import 'currency_chooser_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransactionMainPage extends StatefulWidget {
  TransactionMainPage({super.key, required this.createDrawer});
  final Drawer Function(BuildContext context) createDrawer;
  @override
  State<TransactionMainPage> createState() => _TransactionMainPageState();
  Currency? shownCurrency = null;
}

class _TransactionMainPageState extends State<TransactionMainPage> {
  int _selectedSubPageIndex = 0;
  Future<void> _showEditDialog(Transaction item) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => TransactionEditPage(
                newItem: false,
                item: item,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cp = context.watch<CurrencyProvider>();
    final tp = context.watch<TransactionProvider>();
    //tp.initCurrencies(cp);
    widget.shownCurrency ??= cp.getHomeCurrency();

    if (null == widget.shownCurrency) {
      return const CircularProgressIndicator();
    }

    //var res = tp.calculate(widget.shownCurrency!, null);
    return Scaffold(
      appBar: AppBar(
        /* actions: [
          Text("??"),//Currency.formatValue(res.sumExpense)),
          CurrencyChooserWidget(
              currencies: cp.items,
              selected: widget.shownCurrency!,
              onChanged: (currency) {
                setState(() {
                  widget.shownCurrency = currency;
                });
              })
        ],*/
        title: const Text("Expenses"),
      ),
      body: () {
        if (_selectedSubPageIndex == 1) {
          return TransactionBalanceSubPage(
              transactionProvider: tp, currencyProvider: cp);
        } else if (_selectedSubPageIndex == 2) {
          return ExportWidget(
            name: 'transaction',
            toJson: tp.toJson,
            fromJson: tp.fromJson,
            clearJson: tp.clear,
          );
        } else {
          return TransactionListSubpage(onShowEditDialog: _showEditDialog);
        }
      }(),
      //() {
      //if (_selectedSubPageIndex==0) {TransactionListWidget(
      //  transactionProvider: tp, onShowEditDialog: _showEditDialog)} else {
      //    null
      //  }
      // return TransactionListWidget(
      //     transactionProvider: tp, onShowEditDialog: _showEditDialog);
      //  return Text('tis true');

      //(())}

      //if (_selectedSubPageIndex==0) TransactionListWidget(
      //transactionProvider: tp, onShowEditDialog: _showEditDialog),

      drawer: widget.createDrawer(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //final currency =
          //    CurrencyProvider.getInstance(context).getCurrencyByName('\$');
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TransactionEditPage(
                      newItem: true,
                      item: Transaction(date: DateTime.now(), currency: '\$'),
                    )),
          );
        },
        tooltip: 'Add item',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.list),
            label: 'Entries',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.squarePollHorizontal),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.wrench),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedSubPageIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          setState(() {
            _selectedSubPageIndex = index;
          });
        },
      ),
    );
  }
}
