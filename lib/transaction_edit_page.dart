import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/currency.dart';
import 'package:travel_assist/payment_chooser_widget.dart';
import 'package:travel_assist/payment_provider.dart';
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
  double withdrawFee = 0;

  void saveAndClose(BuildContext context) {
    if (widget.modifiedItem.name.isNotEmpty) {
      widget.item.update(widget.modifiedItem);
      final tp = TransactionProvider.getInstance(context);
      tp.add(widget.item);

      if (widget.newItem &&
          withdrawFee > 0 &&
          widget.modifiedItem.isWithdrawal) {
        final fee = Transaction(
            date: DateTime.now(),
            value: withdrawFee,
            currency: widget.modifiedItem.currency,
            type: TransactionTypeEnum.cardPayment,
            name: 'Withdraw fee for ${widget.modifiedItem.name}',
            categoryKey: ExpenseCategoryManager.getByName("Fee"));
        tp.add(fee);
      }

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

  void onPaymentChanged(Payment payment) {}

  @override
  Widget build(BuildContext context) {
    CurrencyProvider currencyProvider =
        Provider.of<CurrencyProvider>(context, listen: false);

    selectedExpense =
        ExpenseCategoryManager.at(widget.modifiedItem.categoryKey);

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
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
                  autofocus: widget.newItem,
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
                  currencies: currencyProvider.getVisibleItemsWith(
                      currencyProvider
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
                decoration: const InputDecoration(hintText: 'Description'),
                onChanged: (value) => widget.modifiedItem.name = value,
                autofocus: false,
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 18, 0, 12),
                child: SegmentedButton<TransactionTypeEnum>(
                  showSelectedIcon: false,
                  segments: const <ButtonSegment<TransactionTypeEnum>>[
                    ButtonSegment<TransactionTypeEnum>(
                      value: TransactionTypeEnum.cashPayment,
                      icon: FaIcon(FontAwesomeIcons.coins),
                    ),
                    /*ButtonSegment<TransactionTypeEnum>(
                      value: TransactionTypeEnum.cardPayment,
                      icon: FaIcon(FontAwesomeIcons.creditCard),
                    ),*/
                    ButtonSegment<TransactionTypeEnum>(
                      value: TransactionTypeEnum.deposit,
                      icon: FaIcon(FontAwesomeIcons.sackDollar),
                    ),
                    /*ButtonSegment<TransactionTypeEnum>(
                      value: TransactionTypeEnum.exchange,
                      icon: FaIcon(FontAwesomeIcons.moneyBillTransfer),
                    ),
                    ButtonSegment<TransactionTypeEnum>(
                      value: TransactionTypeEnum.withdrawal,
                      icon: Icon(
                        Icons.atm,
                        size: 40,
                      ),
                    ),*/
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

              if (widget.modifiedItem.type == TransactionTypeEnum.cashPayment ||
                  widget.modifiedItem.type ==
                      TransactionTypeEnum.deposit) ...[
                PaymentChooserWidget(onChanged: onPaymentChanged)
              ],

              if (widget.modifiedItem.type == TransactionTypeEnum.cashPayment) ...[
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

              /*
              if (widget.modifiedItem.type == TransactionTypeEnum.withdrawal ||
                  widget.modifiedItem.type ==
                      TransactionTypeEnum.cardPayment) ...[
                TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    decoration: InputDecoration(
                        hintText: 'Card',
                        suffixIcon: IconButton(
                          onPressed: controller.clear,
                          icon: const Icon(Icons.clear),
                        )),
                    controller: controller, //TextEditingController()
                    //..text = widget.modifiedItem.category,
                  ),
                  suggestionsCallback: (pattern) {
                    //widget.modifiedItem.category = pattern;

                    List<String> strlist = epay
                        .where((item) =>
                            item.toLowerCase().contains(pattern.toLowerCase()))
                        .toList();
                    //if (!strlist.contains(pattern)) {
                    //  strlist.insert(0, pattern);
                    //}
                    return strlist;
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    setState(() {
                      // widget.modifiedItem.category = suggestion;
                    });
                  },
                ),
                SingleChildScrollView(
                  //reverse: true,
                  scrollDirection: Axis.horizontal,
                  child: SegmentedButton<TransactionTypeEnum>(
                    showSelectedIcon: false,
                    segments: const <ButtonSegment<TransactionTypeEnum>>[
                      ButtonSegment<TransactionTypeEnum>(
                        value: TransactionTypeEnum.cashPayment,
                        label: Text("Revolut"),
                      ),
                      ButtonSegment<TransactionTypeEnum>(
                        value: TransactionTypeEnum.cardPayment,
                        label: Text("VISA DKB"),
                      ),
                      ButtonSegment<TransactionTypeEnum>(
                        value: TransactionTypeEnum.deposit,
                        label: Text("Revolut"),
                      ),
                      ButtonSegment<TransactionTypeEnum>(
                        value: TransactionTypeEnum.exchange,
                        label: Text("EC"),
                      ),
                      ButtonSegment<TransactionTypeEnum>(
                        value: TransactionTypeEnum.withdrawal,
                        label: Text("VISA PB"),
                      ),
                    ],
                    selected: <TransactionTypeEnum>{widget.modifiedItem.type},
                    onSelectionChanged:
                        (Set<TransactionTypeEnum> newSelection) {
                      setState(() {
                        // widget.modifiedItem.type = newSelection.first;
                      });
                    },
                  ),
                ),
              ],*/
              if (widget.modifiedItem.isWithdrawal && widget.newItem) ...[
                TextField(
                  controller: TextEditingController()
                    ..text = withdrawFee != 0
                        ? Currency.formatValue(withdrawFee)
                        : "",
                  decoration: InputDecoration(
                      hintText: 'Withdraw fee ${widget.modifiedItem.currency}'),
                  onChanged: (value) =>
                      withdrawFee = safeConvertToDouble(value),
                  autofocus: false,
                ),
              ],
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
