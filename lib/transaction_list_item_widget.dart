import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/currency.dart';
import 'package:travel_assist/globals.dart';
import 'currency_provider.dart';
import 'transaction.dart';

class TransactionListItemWidget extends StatelessWidget {
  const TransactionListItemWidget({
    super.key,
    required this.transaction,
    required this.onEditItem,
  });

  final Transaction transaction;
  final void Function(Transaction transaction) onEditItem;

  Widget getIcon(Transaction transaction) {
    switch (transaction.type) {
      case TransactionTypeEnum.expense:
        return AppIcons.expense;
      case TransactionTypeEnum.withdrawal:
        return AppIcons.withdrawal;
      case TransactionTypeEnum.balance:
        return AppIcons.balance;
      case TransactionTypeEnum.deposit:
        return AppIcons.deposit;
    }
  }

  @override
  Widget build(BuildContext context) {
    var currencyProvider = context.watch<CurrencyProvider>();
    const detailStyle = TextStyle(color: Colors.grey, fontSize: 14);
    Currency? homeCurrency = currencyProvider.getHomeCurrency();
    if (null == homeCurrency) {
      return const CircularProgressIndicator();
    }

    final valueHome = currencyProvider
        .convertTo(transaction, currencyProvider.getHomeCurrency())
        .toString();
    final valueLocal = transaction.valueCurrencyString;

    return Card(
        //height: 50,
        child: ListTile(
      onTap: () {
        onEditItem(transaction);
      },
      visualDensity: const VisualDensity(vertical: -4),
      leading: getIcon(transaction),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            Text(transaction.category +
                (transaction.category.isNotEmpty ? " " : "") +
                transaction.name),
            Text(transaction.method, style: detailStyle)
          ], crossAxisAlignment: CrossAxisAlignment.start),
          Column(
              children: [Text(valueHome), Text(valueLocal, style: detailStyle)],
              crossAxisAlignment: CrossAxisAlignment.end),
        ],
      ),
    ));
  }
}
