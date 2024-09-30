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
  static const cashCount = FaIcon(
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
  static const TextStyle subheader =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle method = TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal);
  static const TextStyle normal = TextStyle(
      fontSize: 16, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic);
}

class BorderStyles {
  static final OutlineInputBorder input =
      OutlineInputBorder(borderRadius: BorderRadius.circular(10));
static final BoxDecoration box = 
      BoxDecoration(
              //border: Border.all(color: Colors.blue, width: 2.0), // Border color and width
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0), // Optional: rounded corners
            );
}
