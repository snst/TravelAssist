import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/payment_method_provider.dart';
import 'payment_method.dart';

class PaymentChooserWidget extends StatefulWidget {
  const PaymentChooserWidget({super.key, required this.onChanged, required this.selectedPaymentMethodName});

  final void Function(PaymentMethod paymentMethod) onChanged;
  final String selectedPaymentMethodName;

  @override
  State<PaymentChooserWidget> createState() => _PaymentChooserWidgetState();
}

class _PaymentChooserWidgetState extends State<PaymentChooserWidget> {
  PaymentMethod? selected;
  @override
  Widget build(BuildContext context) {
    PaymentMethodProvider provider =
        Provider.of<PaymentMethodProvider>(context, listen: false);

    selected ??= provider.getByName(widget.selectedPaymentMethodName);
    selected ??= provider.allItems.first;

    List<ButtonSegment<PaymentMethod>> segments = [];
    for (final payment in provider.allItems) {
      segments.add(
          ButtonSegment<PaymentMethod>(value: payment, label: Text(payment.name)));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SegmentedButton<PaymentMethod>(
        showSelectedIcon: false,
        segments: segments,
        selected: <PaymentMethod>{selected!},
        onSelectionChanged: (Set<PaymentMethod> newSelected) {
          setState(() {
            selected = newSelected.first;
            widget.onChanged(newSelected.first);
          });
        },
      ),
    );
  }
}
