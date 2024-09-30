import 'package:flutter/material.dart';
import 'globals.dart';
import 'transaction_value.dart';

enum BalanceRowWidgetEnum {
  normal,
  subheader,
  method,
}

class BalanceRowWidget extends StatelessWidget {
  final String? text1;
  final TransactionValue? tv1;
  final TransactionValue? tv2;
  final TextStyle style;

  BalanceRowWidget({super.key, 
    required this.text1,
    required this.tv1,
    required this.tv2,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
            width: 100.0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text(text1 != null ? text1! : "", style: style),
            )),
        SizedBox(
            width: 100.0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: Text(tv1 != null ? tv1!.roundToString() : "",
                  style: style, textAlign: TextAlign.right),
            )),
        SizedBox(
          width: 140.0,
          child: Text(tv2 != null ? tv2!.roundToString() : "",
              style: style, textAlign: TextAlign.right),
        ),
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
  BalanceRowHeader(this.icon, this.title, this.tv, this.color, {super.key}) {
    style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: AppFonstSize.balanceMainHeader,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
            width: 200.0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text(title, style: style),
            )),
        SizedBox(
            width: 140.0,
            child: Text(tv.roundToString(),
                style: style, textAlign: TextAlign.right)),
      ],
    );
  }
}
