import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/budgetlist_page.dart';
import 'currency_converter_page.dart';
import 'packinglist_model.dart';
import 'packinglist_page.dart';
import 'packinglist.dart';
import 'setting_page.dart';
import 'currency.dart';
import 'settings_model.dart';
import 'transaction.dart';
import 'welcome_page.dart';

void main() async {
  //Hive.registerAdapter(PackingListItemStateFilterEnumAdapter());
  Hive.registerAdapter(PackingListItemStateEnumAdapter());
  Hive.registerAdapter(PackingListItemAdapter());
  Hive.registerAdapter(CurrencyAdapter());
  //Hive.registerAdapter(PackingListAdapter());

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => PackingListModel("default1")),
        ChangeNotifierProvider(create: (context) => SettingsModel()),
        ChangeNotifierProvider(create: (context) => BudgetModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TravelApp',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: const WelcomePage(createDrawer: createDrawer),
    );
  }
}

Drawer createDrawer(BuildContext context) {
  int _selectedIndex = 0;
  //Function void _onItemTapped(int i) => {};
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text('Drawer Header'),
        ),
        ListTile(
          title: const Text('Budget List'),
          selected: _selectedIndex == 0,
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BudgetListPage(createDrawer: createDrawer)));
          },
        ),
        ListTile(
          title: const Text('Packing List'),
          selected: _selectedIndex == 1,
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PackingListPage(
                          title: 'Packing List',
                          createDrawer: createDrawer,
                        )));
          },
        ),
        ListTile(
          title: const Text('Currency Converter'),
          selected: _selectedIndex == 2,
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CurrencyConverterPage(createDrawer: createDrawer)));
          },
        ),
        ListTile(
          title: const Text('Settings'),
          selected: _selectedIndex == 2,
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CurrencySettingPage(createDrawer: createDrawer)));
          },
        ),
      ],
    ),
  );
}
