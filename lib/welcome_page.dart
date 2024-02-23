import 'package:flutter/material.dart';
import 'package:travel_assist/drawer_widget.dart';
import 'package:travel_assist/todo_list_page.dart';
import 'package:travel_assist/transaction_main_page.dart';
import 'package:travel_assist/currency_converter_page.dart';

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
      ],
    );
  }
}
