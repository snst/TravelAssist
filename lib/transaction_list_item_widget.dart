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
    if (transaction.isDeposit) {
      return const FaIcon(FontAwesomeIcons.sackDollar,
          color: Colors.greenAccent);
    } else {
      return ExpenseCategoryManager.at(transaction.categoryKey).icon;
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
            Text(transaction.name),
            Text(transaction.method, style: detailStyle)
          ]),
          Column(
              children: [Text(valueHome), Text(valueLocal, style: detailStyle)])
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
