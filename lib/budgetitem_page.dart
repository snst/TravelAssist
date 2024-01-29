import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'transaction.dart';
import 'settings_model.dart';
import 'currency.dart';
import 'expense_category.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'travel_assist_utils.dart';

class BudgetItemPage extends StatefulWidget {
  BudgetItemPage({
    super.key,
    required this.newItem,
    required this.item,
  })  : title = newItem ? 'Add expense' : 'Edit expense',
        modifiedItem = item.clone();

  final bool newItem;
  final String title;
  final Transaction item;
  final Transaction modifiedItem;

  @override
  State<BudgetItemPage> createState() => _BudgetItemPageState();
}

class _BudgetItemPageState extends State<BudgetItemPage> {
  ExpenseCategory selectedExpense = ExpenseCategoryManager.list[0];

  BudgetModel getExpenseList(BuildContext context) {
    return Provider.of<BudgetModel>(context, listen: false);
  }

  void saveAndClose(BuildContext context) {
    if (widget.modifiedItem.name.isNotEmpty) {
      if (widget.newItem) {
        getExpenseList(context).add(widget.modifiedItem);
      } else {
        widget.item.update(widget.modifiedItem);
        getExpenseList(context).notifyItemChanged(widget.item);
      }
      Navigator.of(context).pop();
    }
  }

  //DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
//      initialDate: _selectedDate ?? DateTime.now(),
      initialDate:  this.widget.modifiedItem.date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != this.widget.modifiedItem.date) {
      setState(() {
        this.widget.modifiedItem.date = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //final TextEditingController controller = TextEditingController();
    //controller.text = widget.modifiedItem.category;
    SettingsModel settings = Provider.of<SettingsModel>(context, listen: false);
    Currency dollar = settings.getCurrency("\$");
    if (widget.newItem) {
      widget.modifiedItem.currency = dollar;
    }
    selectedExpense =
        ExpenseCategoryManager.at(widget.modifiedItem.categoryKey);

    return Scaffold(
      appBar: AppBar(
          //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: //Text(widget.title)),
              Row(
        children: [
          Flexible(
            child: TextField(
              controller: TextEditingController()
                ..text =
                    this.widget.newItem ? "" : widget.modifiedItem.valueStr,
              decoration: const InputDecoration(hintText: 'Amount'),
              onChanged: (value) =>
                  widget.modifiedItem.value = safeConvertToDouble(value),
              autofocus: true,
              style: TextStyle(
                fontSize: 30,
                //color: Colors.blue.shade700,
                fontWeight: FontWeight.w600,
              ),
              autocorrect: false,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
              ],
            ),
          ),
        ],
      )),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: TextEditingController()
                ..text = widget.modifiedItem.name,
              decoration: const InputDecoration(hintText: 'Name'),
              onChanged: (value) => widget.modifiedItem.name = value,
              autofocus: false,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(selectedExpense.name),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ExpenseCategoryManager.list.map((expenseItem) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedExpense = expenseItem;
                          widget.modifiedItem.categoryKey = selectedExpense.id;
                        });
                      },
                      child: FaIcon(
                        expenseItem.icon.icon,
                        size: 40,
                        color: selectedExpense == expenseItem
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            OutlinedButton(
          onPressed: () {
            _selectDate(context);
            //_restorableDatePickerRouteFuture.present();
          },
          child: Text(this.widget.modifiedItem.dateString),
        ),
        /*
            GestureDetector(
              onTap: () {},
              child: Text(
                this.widget.modifiedItem.dateString,
                style: TextStyle(fontSize: 24.0),
              ),
            ),*/
            Row(children: [
              const Spacer(),
              if (!widget.newItem)
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                  child: IconButton(
                      // Delete
                      iconSize: 30,
                      icon: const Icon(
                        Icons.delete_outline,
                      ),
                      //alignment: Alignment.centerRight,
                      onPressed: () {
                        getExpenseList(context).delete(widget.item);
                        //widget.onItemDeleted(widget.item);
                        Navigator.of(context).pop();
                      }),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                child: IconButton(
                    // Save
                    iconSize: 30,
                    icon: const Icon(
                      Icons.check,
                    ),
                    //alignment: Alignment.centerRight,
                    onPressed: () {
                      saveAndClose(context);
                    }),
              ),
            ]),
            TextField(
              controller: TextEditingController()
                ..text = widget.modifiedItem.comment,
              decoration: const InputDecoration(hintText: 'Comment'),
              onChanged: (value) => widget.modifiedItem.comment = value,
              keyboardType: TextInputType.multiline,
              minLines: 10, //Normal textInputField will be displayed
              maxLines: 10, // when user presses enter it will adapt to it
            )
          ],
        ),
      ),
    );
  }
}
