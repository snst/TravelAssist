import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_assist/expense_category.dart';
import 'package:travel_assist/transaction.dart';

class WidgetTransactionExpenseCategoryChooser extends StatefulWidget {
  const WidgetTransactionExpenseCategoryChooser({
    super.key,
    required this.transaction,
  });

  final Transaction transaction;

  @override
  State<WidgetTransactionExpenseCategoryChooser> createState() =>
      _WidgetTransactionExpenseCategoryChooserState();
}

class _WidgetTransactionExpenseCategoryChooserState
    extends State<WidgetTransactionExpenseCategoryChooser> {
  ExpenseCategory? selectedExpense;

  @override
  Widget build(BuildContext context) {
    selectedExpense ??=
        ExpenseCategoryManager.getByIndex(widget.transaction.categoryKey);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ExpenseCategoryManager.list.map((expenseItem) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedExpense = expenseItem;
                        widget.transaction.categoryKey = selectedExpense!.id;
                      });
                    },
                    child: FaIcon(
                      expenseItem.icon.icon,
                      size: 30,
                      color: selectedExpense == expenseItem
                          ? Colors.blue
                          : Colors.grey,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(selectedExpense!.name),
            ),
          )
        ],
      ),
    );
  }
}
