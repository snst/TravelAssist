import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_assist/payment_provider.dart';

class PaymentChooserWidget extends StatefulWidget {
  const PaymentChooserWidget({super.key, required this.onChanged});

  final void Function(Payment payment) onChanged;

  @override
  State<PaymentChooserWidget> createState() => _PaymentChooserWidgetState();
}

class _PaymentChooserWidgetState extends State<PaymentChooserWidget> {
  Payment? selected;
  @override
  Widget build(BuildContext context) {
    PaymentProvider paymentProvider =
        Provider.of<PaymentProvider>(context, listen: false);

    selected ??= paymentProvider.items.first;

    List<ButtonSegment<Payment>> segments = [];
    for (final payment in paymentProvider.items) {
      segments.add(
          ButtonSegment<Payment>(value: payment, label: Text(payment.name)));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SegmentedButton<Payment>(
        showSelectedIcon: false,
        segments: segments,
        selected: <Payment>{selected!},
        onSelectionChanged: (Set<Payment> newSelected) {
          setState(() {
            selected = newSelected.first;
            widget.onChanged(newSelected.first);
          });
        },
      ),
    );
  }
}
