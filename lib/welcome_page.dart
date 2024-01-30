import 'package:flutter/material.dart';
//import 'package:grouped_list/grouped_list.dart';
//import 'package:provider/provider.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage(
      {super.key, required this.createDrawer});
  final Drawer Function(BuildContext context) createDrawer;
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: null,
      drawer: widget.createDrawer(context),
    );
  }
}
