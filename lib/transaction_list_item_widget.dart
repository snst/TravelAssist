import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'currency.dart';
import 'globals.dart';
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
      case TransactionTypeEnum.cashCorrection:
        return AppIcons.cashCount;
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
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(transaction.getCategoryNameStr()),
            Text(transaction.method, style: detailStyle)
          ]),
          Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [Text(valueHome), Text(valueLocal, style: detailStyle)]),
        ],
      ),
    ));
  }
}
