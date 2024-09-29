import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_assist/currency_rates_page.dart';
import 'currency_converter_page.dart';
import 'todo_list_page.dart';
import 'transaction_main_page.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
    required this.controller
  });
  static int selectedPageIndex=0;
  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Text('Menu'),
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.sackDollar),
            title: const Text('Expenses'),
            selected: selectedPageIndex == TransactionMainPage.pageIndex,
            onTap: () {
              controller.jumpToPage(TransactionMainPage.pageIndex);
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.calculator),
            title: const Text('Calculator'),
            selected: selectedPageIndex == CurrencyConverterPage.pageIndex,
            onTap: () {
              controller.jumpToPage(CurrencyConverterPage.pageIndex);
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.list),
            title: const Text('To-do'),
            selected: selectedPageIndex == TodoListPage.pageIndex,
            onTap: () {
              controller.jumpToPage(TodoListPage.pageIndex);
            },
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.arrowTrendUp),
            title: const Text('Currency Rates'),
            selected: selectedPageIndex == CurrencyRatesPage.pageIndex,
            onTap: () {
              controller.jumpToPage(CurrencyRatesPage.pageIndex);
            },
          ),
        ],
      ),
    );
  }
}
