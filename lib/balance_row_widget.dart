import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_assist/transaction_value.dart';

  enum BalanceRowWidgetEnum {
  normal,
  subheader,
  method,
}

class BalanceRowWidget extends StatelessWidget {
  final String? text1;
  final TransactionValue? tv1;
  final TransactionValue? tv2;
  final BalanceRowWidgetEnum styleEnum;



  BalanceRowWidget(
      {required this.text1,
      required this.tv1,
      required this.tv2,
      this.styleEnum = BalanceRowWidgetEnum.normal});

  @override
  Widget build(BuildContext context) {
    final TextStyle style = TextStyle(fontSize: styleEnum==BalanceRowWidgetEnum.subheader ? 18 : 16,
     fontWeight: styleEnum==BalanceRowWidgetEnum.method ? FontWeight.bold : FontWeight.normal);
    //final TextStyle styleBold = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: SizedBox(
              width: 100.0,
              child: Text(text1 != null ? text1! : "", style: style)),
        ),
        SizedBox(
            width: 100.0,
            child: Text(tv1 != null ? tv1.toString() : "", style: style)),
        Text(tv2 != null ? tv2.toString() : "", style: style),
      ],
    );
  }
}

class BalanceRowHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final TransactionValue tv;
  final Color color;
  late TextStyle style;
  BalanceRowHeader(this.icon, this.title, this.tv, this.color) {
    style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20, // Optional: specify font size
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        /*Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
            child: FaIcon(
              icon,
              color: color,
            )),*/
        Padding(
          padding: const EdgeInsets.fromLTRB(15,0,0,0),
          child: SizedBox(width: 200.0, child: Text(title, style: style)),
        ),
        Text(tv.toString(), style: style),
      ],
    );
  }
}
