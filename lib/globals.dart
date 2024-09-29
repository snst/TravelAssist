import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppColors {
  static const expense = Colors.orangeAccent;
  static const withdrawal = Colors.greenAccent;
  static const deposit = Colors.lightGreenAccent;
  static const balance = Colors.lightBlueAccent;
  static const cash = Colors.yellowAccent;
}

class AppIcons {
  static const expense = FaIcon(
    FontAwesomeIcons.cartShopping,
    color: AppColors.expense,
  );
  static const withdrawal = FaIcon(
    FontAwesomeIcons.moneyBills,
    color: AppColors.withdrawal,
  );
  static const deposit = FaIcon(
    FontAwesomeIcons.sackDollar,
    color: AppColors.deposit,
  );
  static const balance = FaIcon(
    FontAwesomeIcons.scaleBalanced,
    color: AppColors.balance,
  );
}

class AppFonstSize {
  static const double balanceMainHeader = 18;
  static const double balanceHeader = 16;
  static const double balanceEntry = 16;
}


class AppBalanceStyle {
  static const TextStyle subheader = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle method = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal);
  static const TextStyle normal = TextStyle(fontSize: 16, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic);

}