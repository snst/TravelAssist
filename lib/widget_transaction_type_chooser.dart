import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_assist/transaction.dart';

class WidgetTransactionTypeChooser extends StatefulWidget {
  const WidgetTransactionTypeChooser({
    super.key,
    required this.transactionType,
    required this.onChanged,
  });

  final TransactionTypeEnum transactionType;
  final Function(TransactionTypeEnum) onChanged;

  @override
  State<WidgetTransactionTypeChooser> createState() =>
      _WidgetTransactionTypeChooserState();
}

class _WidgetTransactionTypeChooserState extends State<WidgetTransactionTypeChooser> {
  TransactionTypeEnum? transactionType;

  @override
  Widget build(BuildContext context) {
    transactionType ??= widget.transactionType;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 18, 0, 12),
      child: SegmentedButton<TransactionTypeEnum>(
        showSelectedIcon: false,
        segments: const <ButtonSegment<TransactionTypeEnum>>[
          ButtonSegment<TransactionTypeEnum>(
            value: TransactionTypeEnum.cashPayment,
            icon: FaIcon(FontAwesomeIcons.coins),
          ),
          ButtonSegment<TransactionTypeEnum>(
            value: TransactionTypeEnum.deposit,
            icon: FaIcon(FontAwesomeIcons.sackDollar),
          ),
          ButtonSegment<TransactionTypeEnum>(
            value: TransactionTypeEnum.balance,
            icon: FaIcon(FontAwesomeIcons.scaleBalanced),
          )
        ],
        selected: <TransactionTypeEnum>{transactionType!},
        onSelectionChanged: (Set<TransactionTypeEnum> newSelection) {
          setState(() {
            transactionType = newSelection.first;
            widget.onChanged(transactionType!);
          });
        },
      ),
    );
  }
}
