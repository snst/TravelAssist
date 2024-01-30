import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/transaction_list_page.dart';
import 'currency_converter_page.dart';
import 'todo_provider.dart';
import 'todo_list_page.dart';
import 'setting_page.dart';
import 'currency_provider.dart';
import 'transaction_provider.dart';
import 'welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TodoProvider()),
        ChangeNotifierProvider(create: (context) => CurrencyProvider()),
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  int selectedIndex = 0;
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
          selected: selectedIndex == 0,
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TransactionListPage(createDrawer: createDrawer)));
          },
        ),
        ListTile(
          title: const Text('Todo List'),
          selected: selectedIndex == 1,
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TodoListPage(
                          title: 'Todo List',
                          createDrawer: createDrawer,
                        )));
          },
        ),
        ListTile(
          title: const Text('Currency Converter'),
          selected: selectedIndex == 2,
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CurrencyConverterPage(
                        createDrawer: createDrawer)));
          },
        ),
        ListTile(
          title: const Text('Settings'),
          selected: selectedIndex == 2,
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CurrencySettingPage(createDrawer: createDrawer)));
          },
        ),
      ],
    ),
  );
}
