import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'currency_provider.dart';
import 'transaction.dart';
import 'expense_category.dart';

class BudgetListItemWidget extends StatelessWidget {
  BudgetListItemWidget({
    required this.item,
    required this.onEditItem,
  }) : super(key: ObjectKey(item));

  final Transaction item;
  final void Function(Transaction item) onEditItem;


  @override
  Widget build(BuildContext context) {
    var currencies = context.watch<CurrencyProvider>();
    const detailStyle = TextStyle(color: Colors.grey, fontSize: 14);
    if (item.currencyKey==0) item.currencyKey=currencies.getHomeCurrency().id;
    if (item.currency==null) item.currency = currencies.getCurrencyById(item.currencyKey);
    final valueHome =
        '${item.getValueStrInCurrency(currencies.getHomeCurrency())} ${currencies.getHomeCurrency().name}';
    final valueLocal = '${item.valueStr} ${item.currency!.name}';

    return SizedBox(
        height: 50,
        child: ListTile(
          onTap: () {
            onEditItem(item);
          },
          //contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0), // add padding here
          visualDensity: const VisualDensity(vertical: -4),
          //dense:true,
          //minVerticalPadding: 0,
          //dense:true,
          //visualDensity:VisualDensity(horizontal: 0, vertical: 0),
          leading: ExpenseCategoryManager.at(item.categoryKey).icon,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.name),
              Text(valueHome),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ExpenseCategoryManager.at(item.categoryKey).name, style: detailStyle),
              Text(valueLocal, style: detailStyle),
            ],
          ),
        ));
  }
}
