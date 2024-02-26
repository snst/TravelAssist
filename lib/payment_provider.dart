import 'package:flutter/material.dart';

class Payment {
  Payment(this.name, this.cash);
  String name;
  bool cash;
}

class PaymentProvider extends ChangeNotifier {
  List<Payment> items = [
    Payment("Cash", true),
    Payment("VISA 1", false),
    Payment("VISA 2", false),
    Payment("Mastercard", false),
    Payment("Paypal", false),
  ];

}
