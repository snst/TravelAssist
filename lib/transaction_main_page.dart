import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/currency.dart';
import 'package:travel_assist/currency_provider.dart';
//import 'package:travel_assist/payment_method.dart';
import 'package:travel_assist/payment_method_provider.dart';
import 'package:travel_assist/currency_rate_widget.dart';
import 'package:travel_assist/payment_method_widget.dart';
import 'package:travel_assist/drawer_widget.dart';
import 'package:travel_assist/transaction_balance_subpage.dart';
import 'package:travel_assist/transaction_list_subpage.dart';
import 'package:travel_assist/transaction_provider.dart';
import 'package:travel_assist/transaction_edit_page.dart';
import 'package:travel_assist/transaction.dart';
import 'package:travel_assist/export_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransactionMainPage extends StatefulWidget {
  const TransactionMainPage({super.key, required this.drawer});
  static int pageIndex = 0;
  final DrawerWidget drawer;
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

  void showPaymentMethodsPage(
      BuildContext context, PaymentMethodProvider paymentMethodProvider) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Payment methods"),
          ),
          body: PaymentMethodsPage(provider: paymentMethodProvider));
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
    final pmp = context.watch<PaymentMethodProvider>();
    shownCurrency ??= cp.getHomeCurrency();

    if (null == shownCurrency) {
      return const CircularProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses"),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              const PopupMenuItem(value: 0, child: Text("Currency rates")),
              const PopupMenuItem(value: 1, child: Text("Payment Methods")),
              const PopupMenuItem(value: 2, child: Text("Settings")),
            ],
            elevation: 2,
            onSelected: (value) {
              switch (value) {
                case 0:
                  showCurrenyRatesPage(context, cp);
                  break;
                case 1:
                  showPaymentMethodsPage(context, pmp);
                  break;
                case 2:
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
        } else {
          return TransactionListSubpage(onShowEditDialog: _showEditDialog);
        }
      }(),
      drawer: widget.drawer,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TransactionEditPage(
                      newItem: true,
                      item: Transaction(date: DateTime.now(), currency: '\$', method: pmp.getDefaultMethod().name),
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
