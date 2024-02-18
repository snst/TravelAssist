import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/currency.dart';
import 'package:travel_assist/currency_converter_page.dart';
import 'package:travel_assist/currency_provider.dart';
import 'package:travel_assist/currency_rate_widget.dart';
import 'package:travel_assist/drawer_widget.dart';
import 'package:travel_assist/transaction_balance_subpage.dart';
import 'package:travel_assist/transaction_list_subpage.dart';
import 'package:travel_assist/transaction_provider.dart';
import 'package:travel_assist/transaction_edit_page.dart';
import 'package:travel_assist/transaction.dart';
import 'package:travel_assist/export_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransactionMainPage extends StatefulWidget {
  const TransactionMainPage({super.key});
  @override
  State<TransactionMainPage> createState() => _TransactionMainPageState();
}

class _TransactionMainPageState extends State<TransactionMainPage> {
  Currency? shownCurrency;
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

  void showCurrenyRatesPage(
      BuildContext context, CurrencyProvider currencyProvider) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Currency rates"),
          ),
          body: CurrencyRatesPage(currencyProvider: currencyProvider));
    }));
  }

  void showCurrencySettingsPage(BuildContext context, TransactionProvider tp) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Settings"),
          ),
          body: ExportWidget(
            name: 'transaction',
            toJson: tp.toJson,
            fromJson: tp.fromJson,
            clearJson: tp.clear,
          ));
    }));
  }

  @override
  Widget build(BuildContext context) {
    final cp = context.watch<CurrencyProvider>();
    final tp = context.watch<TransactionProvider>();
    shownCurrency ??= cp.getHomeCurrency();

    if (null == shownCurrency) {
      return const CircularProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Money"),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              const PopupMenuItem(value: 0, child: Text("Currency rates")),
              const PopupMenuItem(value: 1, child: Text("Settings")),
            ],
            elevation: 2,
            onSelected: (value) {
              switch (value) {
                case 0:
                  showCurrenyRatesPage(context, cp);
                  break;
                case 1:
                  showCurrencySettingsPage(context, tp);
                  break;
              }
            },
          ),
        ],
      ),
      body: () {
        if (_selectedSubPageIndex == 1) {
          return TransactionBalanceSubPage(
              transactionProvider: tp, currencyProvider: cp);
        } else if (_selectedSubPageIndex == 2) {
          return CurrencyConverterWidget(
            currencyProvider: cp,
          );
        } else {
          return TransactionListSubpage(onShowEditDialog: _showEditDialog);
        }
      }(),
      drawer: const DrawerWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
            icon: FaIcon(FontAwesomeIcons.calculator),
            label: 'Calculator',
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
