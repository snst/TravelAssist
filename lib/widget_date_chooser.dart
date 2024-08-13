import 'package:flutter/material.dart';
//import 'package:travel_assist/formatter.dart';

class WidgetDateChooser extends StatefulWidget {
  const WidgetDateChooser({
    super.key,
    required this.date,
    required this.onChanged,
  });

  final DateTime date;
  final Function(DateTime) onChanged;

  @override
  State<WidgetDateChooser> createState() => _WidgetDateChooserState();
}

class _WidgetDateChooserState extends State<WidgetDateChooser> {
  DateTime? date;
  @override
  Widget build(BuildContext context) {
    date ??= widget.date;

    return IconButton(
            // Back
            iconSize: 30,
            icon: const Icon(
              Icons.calendar_month_outlined,
            ),
            onPressed: () {
              selectDate(context);
            });

    /*
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton(
        onPressed: () {
          selectDate(context);
        },
        child: Text(Formatter.dateToString(date)),
      ),
    );*/
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != date) {
      setState(() {
        date = picked;
        widget.onChanged(date!);
      });
    }
  }
}
