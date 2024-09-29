import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/globals.dart';
import 'currency.dart';
import 'transaction_provider.dart';
import 'transaction_value.dart';
import 'widget_combobox.dart';
import 'widget_date_chooser.dart';
import 'widget_transaction_description_input.dart';
import 'transaction.dart';
import 'currency_provider.dart';
import 'travel_assist_utils.dart';
import 'currency_chooser_widget.dart';
import 'package:flutter_spinbox/material.dart';

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
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController paymentMethodController = TextEditingController();

  void saveAndClose(BuildContext context) {
    final tp = TransactionProvider.getInstance(context);
    /*if (widget.modifiedItem.name.isEmpty) {
      if (widget.modifiedItem.type == TransactionTypeEnum.balance) {
        CurrencyProvider cp = CurrencyProvider.getInstance(context);
        Currency? currency = cp.getCurrencyByName(widget.modifiedItem.currency);
        TransactionValue val = tp.calcBalance(cp, currency);
        double difference = val.value - widget.modifiedItem.value;
        widget.modifiedItem.name =
            "Balance ${widget.modifiedItem.valueCurrencyString}";
        widget.modifiedItem.value = difference;
      }
    }*/
    switch (widget.modifiedItem.type) {
      case TransactionTypeEnum.balance:
        CurrencyProvider cp = CurrencyProvider.getInstance(context);
        Currency? currency = cp.getCurrencyByName(widget.modifiedItem.currency);
        TransactionValue val = tp.calcBalance(cp, currency);
        double difference = val.value - widget.modifiedItem.value;
        widget.modifiedItem.name = widget.modifiedItem.valueCurrencyString;
        widget.modifiedItem.value = difference;
        widget.modifiedItem.method = "";
        break;
      //case TransactionTypeEnum.expense:
      default:
        widget.modifiedItem.category = categoryController.text;
        widget.modifiedItem.method = paymentMethodController.text;
        break;
      /*
      case TransactionTypeEnum.deposit:
        widget.modifiedItem.category = "Deposit";
        widget.modifiedItem.method = "";
        break;
      case TransactionTypeEnum.withdrawal:
        widget.modifiedItem.category = "Withdrawal";
        break;*/
    }

    widget.item.update(widget.modifiedItem);
    tp.add(widget.item);

    Navigator.of(context).pop();
  }

  void _onItemSelected(String method) {
    setState(() {
      widget.modifiedItem.method = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    CurrencyProvider currencyProvider =
        Provider.of<CurrencyProvider>(context, listen: false);

    final l =
        TransactionProvider.getInstance(context).getPaymentMethodList(false);
    if (l.isNotEmpty) {
      if (widget.modifiedItem.method == "") widget.modifiedItem.method = l[0];
    }

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: widgetAmountInput(currencyProvider)),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: <Widget>[
              if (widget.modifiedItem.type == TransactionTypeEnum.expense) ...[
                // CATEGORY
                WidgetComboBox(
                  controller: categoryController,
                  selectedText: widget.modifiedItem.category,
                  hintText: 'Category',
                  filter: true,
                  onChanged: (p0) {
                    setState(() {
                      widget.modifiedItem.category = p0;
                    });
                  },
                  items: TransactionProvider.getInstance(context)
                      .getCategoryList(),
                ),
              ],
              // DESCRIPTION
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: WidgetTransactionDescriptionInput(
                  widget: widget,
                  hintText: "Description",
                ),
              ),
              if (widget.modifiedItem.type == TransactionTypeEnum.expense)
                ...[],
              Row(
                children: [
                  SizedBox(
                    width: 130,
                    child: Container(
                      decoration: BorderStyles.box,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 3, 1, 3),
                        child: DropdownButton(
                          value: widget.modifiedItem.type,
                          isExpanded: true,
                          underline: SizedBox(),
                          // decoration: ,
                          items: const [
                            DropdownMenuItem(
                                value: TransactionTypeEnum.expense,
                                child: Text("Expense")),
                            DropdownMenuItem(
                                value: TransactionTypeEnum.withdrawal,
                                child: Text("Withdrawal")),
                            DropdownMenuItem(
                                value: TransactionTypeEnum.balance,
                                child: Text("Correction")),
                            DropdownMenuItem(
                                value: TransactionTypeEnum.deposit,
                                child: Text("Deposit")),
                          ],
                          onChanged: (value) {
                            setState(() {
                              widget.modifiedItem.type = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  if (widget.modifiedItem.type == TransactionTypeEnum.expense ||
                      widget.modifiedItem.type ==
                          TransactionTypeEnum.withdrawal) ...[
                    Expanded(
                      child: WidgetComboBox(
                        controller: paymentMethodController,
                        selectedText: widget.modifiedItem.method,
                        hintText: '',
                        filter: false,
                        onChanged: (p0) {
                          setState(() {
                            widget.modifiedItem.method = p0;
                          });
                        },
                        items: TransactionProvider.getInstance(context)
                            .getPaymentMethodList(widget.modifiedItem.type ==
                                TransactionTypeEnum.withdrawal),
                      ),
                    ),
                  ],
                ],
              ),

              if (widget.modifiedItem.type == TransactionTypeEnum.expense) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Row(
                    children: [
                      const Spacer(),
                      SpinBox(
                        value: widget.modifiedItem.averageDays.toDouble(),
                        decoration: const InputDecoration(
                            constraints: BoxConstraints.tightFor(
                              width: 170,
                            ),
                            labelText: 'Average Days'),
                        onChanged: (value) =>
                            widget.modifiedItem.averageDays = value.toInt(),
                      ),
                    ],
                  ),
                ),
              ],
              widgetButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Row widgetAmountInput(CurrencyProvider currencyProvider) {
    return Row(
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
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
    );
  }

  Padding widgetButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Row(children: [
        WidgetDateChooser(
          date: widget.modifiedItem.date,
          onChanged: (val) => setState(() {
            widget.modifiedItem.date = val;
          }),
        ),
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
                  TransactionProvider.getInstance(context).delete(widget.item);
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
    );
  }
}
