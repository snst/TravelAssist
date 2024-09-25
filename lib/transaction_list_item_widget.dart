import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/currency.dart';
import 'currency_provider.dart';
import 'transaction.dart';
import 'expense_category.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        return const FaIcon(
          FontAwesomeIcons.cartShopping,
          color: Colors.orangeAccent,
        );
      case TransactionTypeEnum.withdrawal:
        return const FaIcon(
          FontAwesomeIcons.moneyBills,
          color: Colors.greenAccent,
        );
      case TransactionTypeEnum.balance:
        return const FaIcon(
          FontAwesomeIcons.scaleBalanced,
          color: Colors.blueAccent,
        );
      case TransactionTypeEnum.deposit:
        return const FaIcon(
          FontAwesomeIcons.sackDollar,
          color: Colors.lightBlueAccent,
        );
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
      /*subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Text(ExpenseCategoryManager.at(item.categoryKey).name, style: detailStyle),
              Text(valueLocal, style: detailStyle),
            ],
          ),*/
    ));
  }
}
