import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/transaction_provider.dart';
import 'transaction.dart';
import 'currency_provider.dart';
import 'expense_category.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'travel_assist_utils.dart';
import 'currency_chooser_widget.dart';

class TransactionEditPage extends StatefulWidget {
  TransactionEditPage({
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
  State<TransactionEditPage> createState() => _TransactionEditPageState();
}

class _TransactionEditPageState extends State<TransactionEditPage> {
  ExpenseCategory selectedExpense = ExpenseCategoryManager.list[0];
  //bool modified = false;

  void saveAndClose(BuildContext context) {
    if (widget.modifiedItem.name.isNotEmpty) {
      widget.item.update(widget.modifiedItem);
      TransactionProvider.getInstance(context).add(widget.item);
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.modifiedItem.date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != widget.modifiedItem.date) {
      setState(() {
        widget.modifiedItem.date = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CurrencyProvider currencyProvider =
        Provider.of<CurrencyProvider>(context, listen: false);

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
              textAlign: TextAlign.right,
              controller: TextEditingController()
                ..text = widget.modifiedItem.value == 0
                    ? ""
                    : widget.modifiedItem.valueString,
              decoration: const InputDecoration(hintText: 'Amount'),
              onChanged: (value) {
                //modified = true;
                widget.modifiedItem.value = safeConvertToDouble(value);
              },
              autofocus: true,
              style: const TextStyle(
                fontSize: 30,
                //color: Colors.blue.shade700,
                fontWeight: FontWeight.w600,
              ),
              autocorrect: false,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
              ],
            ),
          ),
          CurrencyChooserWidget(
              currencies: currencyProvider.getVisibleItemsWith(currencyProvider
                  .getCurrencyFromTransaction(widget.modifiedItem)),
              selected: currencyProvider
                  .getCurrencyFromTransaction(widget.modifiedItem),
              onChanged: (currency) {
                setState(() {
                  widget.modifiedItem.currency = currency.name;
                });
              })
        ],
      )),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: SingleChildScrollView(
          reverse: true,
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
              if (!widget.modifiedItem.isWithdrawal) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(selectedExpense.name),
                  ),
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
                              widget.modifiedItem.categoryKey =
                                  selectedExpense.id;
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
                CheckboxListTile(
                  title: const Text('Exclude from daily average'),
                  value: widget.modifiedItem.exlcudeFromAverage,
                  onChanged: (bool? value) {
                    setState(() {
                      widget.modifiedItem.exlcudeFromAverage = value!;
                    });
                  },
//                secondary: const Icon(Icons.today),
                  secondary: const FaIcon(FontAwesomeIcons.calendarDay),
                ),
                /*CheckboxListTile(
                title: const Text('Exclude from cash balance'),
                value: widget.modifiedItem.exludeFromCashBalance,
                onChanged: (bool? value) {
                  setState(() {
                    widget.modifiedItem.exludeFromCashBalance = value!;
                  });
                },
                secondary: const FaIcon(FontAwesomeIcons.scaleBalanced),
              ),*/
              ],
              /*
              CheckboxListTile(
                title: const Text('Chash withdraw'),
                value: widget.modifiedItem.isCashWithdraw,
                onChanged: (bool? value) {
                  setState(() {
                    widget.modifiedItem.isCashWithdraw = value!;
                  });
                },
                secondary: const FaIcon(FontAwesomeIcons.sackDollar),
              ),*/
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 18, 0, 12),
                child: SegmentedButton<TransactionTypeEnum>(
                  showSelectedIcon: false,
                  segments: const <ButtonSegment<TransactionTypeEnum>>[
                    ButtonSegment<TransactionTypeEnum>(
                      value: TransactionTypeEnum.cashPayment,
                      icon: FaIcon(FontAwesomeIcons.coins),
                    ),
                    ButtonSegment<TransactionTypeEnum>(
                      value: TransactionTypeEnum.cardPayment,
                      icon: FaIcon(FontAwesomeIcons.creditCard),
                    ),
                    ButtonSegment<TransactionTypeEnum>(
                      value: TransactionTypeEnum.electronicPayment,
                      icon: FaIcon(FontAwesomeIcons.paypal),
                    ),
                    ButtonSegment<TransactionTypeEnum>(
                      value: TransactionTypeEnum.withdrawal,
                      icon: FaIcon(FontAwesomeIcons.moneyBills),
                    ),
                    ButtonSegment<TransactionTypeEnum>(
                      value: TransactionTypeEnum.balance,
                      icon: FaIcon(FontAwesomeIcons.scaleBalanced),
                    )
                  ],
                  selected: <TransactionTypeEnum>{widget.modifiedItem.type},
                  onSelectionChanged: (Set<TransactionTypeEnum> newSelection) {
                    setState(() {
                      widget.modifiedItem.type = newSelection.first;
                    });
                  },
                ),
              ),
              /*
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
                  child: Center(
                      child: ToggleSwitch(
                    initialLabelIndex: switch (widget.modifiedItem.type) {
                      TransactionTypeEnum.cashPayment => 0,
                      TransactionTypeEnum.cardPayment => 1,
                      TransactionTypeEnum.electronicPayment => 2,
                      TransactionTypeEnum.withdrawal => 3,
                      TransactionTypeEnum.balance => 4,
                    },
                    totalSwitches: 5,
                    labels: const [
                      'Cash',
                      'Card',
                      'Paypal',
                      'Withdrawal',
                      'Balance'
                    ],
                    onToggle: (index) {
                      widget.modifiedItem.type = switch (index) {
                        1 => TransactionTypeEnum.cardPayment,
                        2 => TransactionTypeEnum.electronicPayment,
                        3 => TransactionTypeEnum.withdrawal,
                        4 => TransactionTypeEnum.withdrawal,
                        _ => TransactionTypeEnum.cashPayment
                      };
                    },
                  ))),*/
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlinedButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: Text(widget.modifiedItem.dateString),
                ),
              ),
              /*
              GestureDetector(
                onTap: () {},
                child: Text(
                  this.widget.modifiedItem.dateString,
                  style: TextStyle(fontSize: 24.0),
                ),
              ),*/
              TextField(
                controller: TextEditingController()
                  ..text = widget.modifiedItem.comment,
                decoration: const InputDecoration(hintText: 'Comment'),
                onChanged: (value) => widget.modifiedItem.comment = value,
                keyboardType: TextInputType.multiline,
                minLines: 1, //Normal textInputField will be displayed
                maxLines: 8, // when user presses enter it will adapt to it
                //scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                //scrollPadding: EdgeInsets.symmetric( vertical: MediaQuery.of(context).viewInsets.bottom),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(children: [
                  const Spacer(),
                  IconButton(
                      // Back
                      iconSize: 30,
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  if (!widget.newItem)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                      child: IconButton(
                          // Delete
                          iconSize: 30,
                          icon: const Icon(
                            Icons.delete_outline,
                          ),
                          onPressed: () {
                            TransactionProvider.getInstance(context)
                                .delete(widget.item);
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
              ),
              //SizedBox(height:MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
