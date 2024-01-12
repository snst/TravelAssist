import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'packinglist_page.dart';
import 'packinglist.dart';
import 'currency_setting_page.dart';
import 'currency.dart';

void main() async {
  //Hive.registerAdapter(PackingListItemStateFilterEnumAdapter());
  Hive.registerAdapter(PackingListItemStateEnumAdapter());
  Hive.registerAdapter(PackingListItemAdapter());
  Hive.registerAdapter(PackingListAdapter());

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('packinglist2');

  runApp(
    ChangeNotifierProvider(
      create: (context) => PackingList("a"),
      child: MyApp(),
    ),
  );

  //runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  //final CurrencyList _currencyList = CurrencyList();

  // This widget is the root of your application.
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
      home: PackingListPage(title: 'TravelApp', createDrawer: createDrawer),
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
          title: const Text('Money'),
          selected: _selectedIndex == 0,
          onTap: () {
            //_onItemTapped(0);
            //Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Packing List.'),
          selected: _selectedIndex == 1,
          onTap: () {
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
          title: const Text('Currency'),
          selected: _selectedIndex == 2,
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CurrencySettingPage()));
          },
        ),
        ListTile(
          title: const Text('Settings'),
          selected: _selectedIndex == 2,
          onTap: () {
            //_onItemTapped(3);
            //Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
