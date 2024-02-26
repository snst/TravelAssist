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
    ExpenseCategory("Paypal", const FaIcon(FontAwesomeIcons.paypal)),
    ExpenseCategory("Present", const FaIcon(FontAwesomeIcons.gift)),
    ExpenseCategory("Entertainment", const FaIcon(FontAwesomeIcons.masksTheater)),
    ExpenseCategory("Credit card", const FaIcon(FontAwesomeIcons.creditCard)),
  ];

  static int getByName(String name) {
    return list.firstWhere((element) => element.name == name).id;
  }

  static ExpenseCategory at(int i) => list[i];

  static getByIndex(int i) {
    return i >= 0 && i < list.length ? list[i] : list[0];
  }
}
