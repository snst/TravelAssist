import 'package:flutter/material.dart';

class HorizontalSelector extends StatefulWidget {
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  HorizontalSelector({
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  _HorizontalSelectorState createState() => _HorizontalSelectorState();
}

class _HorizontalSelectorState extends State<HorizontalSelector> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0, // Height of the selector container
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final bool isSelected = _selectedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
              widget.onItemSelected(index);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: isSelected ? Colors.blueAccent : Colors.grey[800]!,
                  width: 2.0,
                ),
              ),
              child: Center(
                child: Text(
                  widget.items[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
