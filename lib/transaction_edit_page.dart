import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/payment_chooser_widget.dart';
//import 'package:travel_assist/payment_provider.dart';
import 'package:travel_assist/transaction_provider.dart';
import 'package:travel_assist/widget_transaction_expense_category_chooser.dart';
import 'package:travel_assist/widget_transaction_type_chooser.dart';
import 'package:travel_assist/widget_comment_input.dart';
import 'package:travel_assist/widget_date_chooser.dart';
import 'package:travel_assist/widget_transaction_description_input.dart';
import 'package:travel_assist/widget_transaction_withdrawal_fee_input.dart';
import 'transaction.dart';
import 'currency_provider.dart';
import 'expense_category.dart';
import 'travel_assist_utils.dart';
import 'currency_chooser_widget.dart';
import 'payment_method.dart';
import 'payment_method_provider.dart';

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
  double withdrawFee = 0;
  PaymentMethod? paymentMethod;

  void saveAndClose(BuildContext context) {
    if (widget.modifiedItem.name.isEmpty) {
      if (widget.modifiedItem.type == TransactionTypeEnum.expense) {
        widget.modifiedItem.name =
            ExpenseCategoryManager.getByIndex(widget.modifiedItem.categoryKey)
                .name;
      }
      else if (widget.modifiedItem.type == TransactionTypeEnum.deposit) {
        widget.modifiedItem.name = "Deposit";
      } else {
        widget.modifiedItem.name = "?";
      }
    }
    widget.modifiedItem.method = paymentMethod!.name;
    widget.item.update(widget.modifiedItem);
    final tp = TransactionProvider.getInstance(context);
    tp.add(widget.item);

    if (widget.newItem && withdrawFee > 0 && widget.modifiedItem.isWithdrawal) {
      final fee = Transaction(
          date: DateTime.now(),
          value: withdrawFee,
          currency: widget.modifiedItem.currency,
          type: TransactionTypeEnum.expense,
          name: 'Withdraw fee for ${widget.modifiedItem.name}',
          method: paymentMethod!.name,
          categoryKey: ExpenseCategoryManager.getByName("Fee"));
      tp.add(fee);
    }

    Navigator.of(context).pop();
  }

  void onPaymentChanged(PaymentMethod payment) {
    setState(() {
      paymentMethod = payment;
      widget.modifiedItem.method = payment.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    CurrencyProvider currencyProvider =
        Provider.of<CurrencyProvider>(context, listen: false);
    PaymentMethodProvider provider =
        Provider.of<PaymentMethodProvider>(context, listen: false);

    paymentMethod ??= provider.allItems.first;

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
              WidgetTransactionDescriptionInput(
                  widget: widget, hintText: getHint(widget.modifiedItem.type)),
              if (widget.modifiedItem.type == TransactionTypeEnum.expense ||
                  widget.modifiedItem.type == TransactionTypeEnum.deposit) ...[
                PaymentChooserWidget(onChanged: onPaymentChanged)
              ],
              if (widget.modifiedItem.type == TransactionTypeEnum.expense) ...[
                WidgetTransactionExpenseCategoryChooser(
                    transaction: widget.modifiedItem),
                widgetExcludeFromDailyAverage(),
              ],
              WidgetTransactionTypeChooser(
                transactionType: widget.modifiedItem.type,
                onChanged: (val) => setState(() {
                  widget.modifiedItem.type = val;
                }),
              ),
              if (widget.modifiedItem.isWithdrawal && widget.newItem) ...[
                WidgetTransactionWithdrawalFeeInput(
                  transaction: widget.modifiedItem,
                  onChanged: (value) {
                    withdrawFee = value;
                  },
                ),
              ],
              WidgetDateChooser(
                date: widget.modifiedItem.date,
                onChanged: (val) => setState(() {
                  widget.modifiedItem.date = val;
                }),
              ),
              widgetButtons(context),
              WidgetCommentInput(
                  comment: widget.modifiedItem.comment,
                  onChanged: (val) => setState(() {
                        widget.modifiedItem.comment = val;
                      })),
            ],
          ),
        ),
      ),
    );
  }

  CheckboxListTile widgetExcludeFromDailyAverage() {
    return CheckboxListTile(
      title: const Text('Exclude from daily average'),
      value: widget.modifiedItem.exlcudeFromAverage,
      onChanged: (bool? value) {
        setState(() {
          widget.modifiedItem.exlcudeFromAverage = value!;
        });
      },
      //secondary: const FaIcon(FontAwesomeIcons.calendarDay),
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
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
