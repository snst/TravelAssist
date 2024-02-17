import 'package:flutter/material.dart';
import 'package:travel_assist/currency_page.dart';
import 'package:travel_assist/todo_list_page.dart';
import 'package:travel_assist/transaction_main_page.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
  });
  static int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            //decoration: BoxDecoration(
            //  color: Theme.of(context).drawerTheme.surfaceTintColor,
            //),
            child: Text('Menu'),
          ),
          ListTile(
            title: const Text('Budget'),
            selected: selectedIndex == 0,
            onTap: () {
              selectedIndex = 0;
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TransactionMainPage()));
            },
          ),
          ListTile(
            title: const Text('To-do'),
            selected: selectedIndex == 1,
            onTap: () {
              selectedIndex = 1;
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TodoListPage()));
            },
          ),
          ListTile(
            title: const Text('Currency'),
            selected: selectedIndex == 2,
            onTap: () {
              selectedIndex = 2;
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CurrencyPage()));
            },
          ),
          /*ListTile(
            title: const Text('Settings'),
            selected: selectedIndex == 3,
            onTap: () {
              selectedIndex = 3;
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CurrencySettingPage()));
            },
          ),*/
        ],
      ),
    );
  }
}
