import 'package:flutter/material.dart';
import 'package:travel_assist/currency.dart';
import 'package:travel_assist/transaction.dart';
import 'package:travel_assist/travel_assist_utils.dart';

class WidgetTransactionWithdrawalFeeInput extends StatelessWidget {
  const WidgetTransactionWithdrawalFeeInput({
    super.key,
    required this.transaction,
    required this.onChanged,
  });

  final Transaction transaction;
  final double withdrawFee = 0;
  final Function(double) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController()
        ..text = withdrawFee != 0 ? Currency.formatValue(withdrawFee) : "",
      decoration: InputDecoration(
          hintText: 'Withdraw fee ${transaction.currency}'),
      onChanged: (value) => { onChanged(safeConvertToDouble(value)) },
      autofocus: false,
    );
  }
}