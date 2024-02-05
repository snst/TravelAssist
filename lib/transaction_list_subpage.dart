import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/transaction.dart';
import 'package:travel_assist/transaction_provider.dart';
import 'package:travel_assist/transaction_list_item_widget.dart';

class TransactionListSubpage extends StatefulWidget {
  TransactionListSubpage({
    super.key,
    required this.onShowEditDialog,
  });
  final void Function(Transaction currency) onShowEditDialog;

  @override
  State<TransactionListSubpage> createState() => _TransactionListSubpageState();
}

class _TransactionListSubpageState extends State<TransactionListSubpage> {
  @override
  Widget build(BuildContext context) {
    //final currencyProvider = context.watch<CurrencyProvider>();
    final transactionProvider = context.watch<TransactionProvider>();

    return GroupedListView<Transaction, DateTime>(
      shrinkWrap: true,
      elements: transactionProvider.getSortedTransactions(null),
      groupBy: (Transaction element) => element.groupDate,
      itemComparator: (Transaction element1, Transaction element2) =>
          element1.date.compareTo(element2.date),
      order: GroupedListOrder.DESC,
      useStickyGroupSeparators: false,
      groupSeparatorBuilder: (DateTime value) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Container(
          //color: Colors.grey.shade900,
          color: Theme.of(context).hoverColor,
          child: Text(
            DateFormat('  EEEE, d MMMM y').format(value),
            textAlign: TextAlign.left,
          ),
        ),
      ),
      itemBuilder: (context, item) => TransactionListItemWidget(
        transaction: item,
        onEditItem: widget.onShowEditDialog,
      ),
    );
  }
}
