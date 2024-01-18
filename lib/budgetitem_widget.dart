import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_model.dart';
import 'transaction.dart';

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
    final valueHome = '${item.getValueStrInCurrency(currencies.getHomeCurrency())} ${currencies.getHomeCurrency().name}';
    final valueLocal = '${item.valueStr} ${item.currency!.name}';

    return ListTile(
      onTap: () {
        onEditItem(item);
      },
      minVerticalPadding: 0,
      //dense:true,
      //visualDensity:VisualDensity(horizontal: 0, vertical: 4),
      leading: Icon(Icons.train),
/*
      title: Row(children: [
        Expanded(child: Column(children: [
          Text(item.name, textAlign:TextAlign.left),
          Text(item.category, style: detailStyle),
        ])),
        Column(children: [
        Text(valueHome),
        Text(valueLocal, style: detailStyle),
        ]),
      ]*/
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.name),
              Text(item.category, style: detailStyle),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(valueHome),
              Text(valueLocal, style: detailStyle),
            ],
          ),
        ],
      ),
      
      
    );
  }
}
