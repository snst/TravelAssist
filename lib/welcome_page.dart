import 'package:flutter/material.dart';
import 'currency_rates_page.dart';
import 'drawer_widget.dart';
import 'todo_list_page.dart';
import 'transaction_main_page.dart';
import 'currency_converter_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    final drawer = DrawerWidget(controller: controller);
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: controller,
      onPageChanged: (value) => DrawerWidget.selectedPageIndex = value,
      children: <Widget>[
        TransactionMainPage(drawer: drawer),
        CurrencyConverterPage(drawer: drawer),
        TodoListPage(drawer: drawer),
        CurrencyRatesPage(drawer: drawer),
      ],
    );
  }
}
