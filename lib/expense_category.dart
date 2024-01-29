import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/currency.dart';
import 'package:travel_assist/settings_model.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpenseCategory {
  static int _nextId = 0;

  ExpenseCategory(this.name, this.icon) {
    id = _nextId++;
  }

  String name;
  int id = 0;
  FaIcon icon;
}

class ExpenseCategoryManager {
  static final List<ExpenseCategory> list = [
    ExpenseCategory("Restaurant", const FaIcon(FontAwesomeIcons.utensils)),
    ExpenseCategory("Transport", const FaIcon(FontAwesomeIcons.bus)),
    ExpenseCategory("Accomodation", const FaIcon(FontAwesomeIcons.bed)),
    ExpenseCategory("Drink", const FaIcon(FontAwesomeIcons.bottleWater)),
    ExpenseCategory("Food", const FaIcon(FontAwesomeIcons.pizzaSlice)),
    ExpenseCategory("Cafe", const FaIcon(FontAwesomeIcons.mugHot)),
    ExpenseCategory("Shopping", const FaIcon(FontAwesomeIcons.cartShopping)),
    ExpenseCategory("Flight", const FaIcon(FontAwesomeIcons.plane)),
    ExpenseCategory("Activity", const FaIcon(FontAwesomeIcons.personHiking)),
    ExpenseCategory("Fee", const FaIcon(FontAwesomeIcons.moneyBill1)),
    ExpenseCategory("Laundry", const FaIcon(FontAwesomeIcons.shirt)),
    ExpenseCategory("ATM", const FaIcon(FontAwesomeIcons.sackDollar)),
    ExpenseCategory("Present", const FaIcon(FontAwesomeIcons.gift)),
    ExpenseCategory("Entertainment", const FaIcon(FontAwesomeIcons.masksTheater)),
  ];

  static ExpenseCategory at(int i) => list[i];
}
