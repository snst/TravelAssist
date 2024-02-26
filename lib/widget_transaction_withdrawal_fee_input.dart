import 'package:flutter/material.dart';
import 'package:travel_assist/currency.dart';
import 'package:travel_assist/transaction.dart';

class WidgetTransactionWithdrawalFeeInput extends StatelessWidget {
  const WidgetTransactionWithdrawalFeeInput({
    super.key,
    required this.transaction,
  });

  final Transaction transaction;
  final double withdrawFee = 0;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController()
        ..text = withdrawFee != 0 ? Currency.formatValue(withdrawFee) : "",
      decoration: InputDecoration(
          hintText: 'Withdraw fee ${transaction.currency}'),
      onChanged: (value) => {}, //withdrawFee = safeConvertToDouble(value),
      autofocus: false,
    );
  }
}
