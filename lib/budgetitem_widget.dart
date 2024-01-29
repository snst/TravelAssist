import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_model.dart';
import 'transaction.dart';
import 'expense_category.dart';

class BudgetListItemWidget extends StatelessWidget {
  BudgetListItemWidget({
    required this.item,
    required this.onEditItem,
  }) : super(key: ObjectKey(item));

  final Transaction item;
  final void Function(Transaction item) onEditItem;

  TextStyle? _getTextStyle(TransactionEnum state) {
    return null;
    /*
    switch (state) {
      case PackingListItemStateEnum.missing:
        return const TextStyle(color: Colors.amber);
      case PackingListItemStateEnum.skipped:
        return const TextStyle(
          decoration: TextDecoration.lineThrough,
        );
      default:
        return null;
    }*/
  }

  @override
  Widget build(BuildContext context) {
    var currencies = context.watch<SettingsModel>();
    const detailStyle = const TextStyle(color: Colors.grey, fontSize: 14);
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
          visualDensity: VisualDensity(vertical: -4),
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
