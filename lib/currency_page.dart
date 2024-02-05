import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/currency_converter_page.dart';
import 'package:travel_assist/currency_setting_widget.dart';
import 'package:travel_assist/drawer_widget.dart';
import 'currency_provider.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});
  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  int _selectedBottomIndex = 0;

  @override
  Widget build(BuildContext context) {
    final cp = context.watch<CurrencyProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Currency"),
      ),
      body: () {
        if (_selectedBottomIndex == 1) {
          return CurrencySettingPage(currencyProvider: cp);
        } else {
          return CurrencyConverterWidget(currencyProvider: cp);
        }
      }(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.calculator),
            //Icon(Icons.arrow_downward),
            label: 'Calculator',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.arrowRightArrowLeft),
            label: 'Rates',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.wrench),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedBottomIndex,
        //selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        //unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        onTap: (index) {
          setState(() {
            _selectedBottomIndex = index;
          });
        },
      ),
      drawer: const DrawerWidget(),
    );
  }
}
