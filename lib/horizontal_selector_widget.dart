import 'package:flutter/material.dart';

class HorizontalListView extends StatefulWidget {
  final List<String> items;
  final String selected;
  final ValueChanged<String> onItemSelected;

  HorizontalListView({super.key, 
    required this.items,
    required this.selected,
    required this.onItemSelected,
  });

  @override
  _HorizontalListViewState createState() => _HorizontalListViewState();
}

class _HorizontalListViewState extends State<HorizontalListView> {
  late ScrollController _scrollController;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.items.indexOf(widget.selected);
    if (_selectedIndex == -1) _selectedIndex = 0;
    _scrollController = ScrollController();

    // Scroll to the initial index after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToInitialIndex();
    });
  }

  void _scrollToInitialIndex() {
    double offset = 0;
    double screenWidth = MediaQuery.of(context).size.width;

    for (int i = 0; i < _selectedIndex; i++) {
      offset += _calculateItemWidth(i);
    }

    // Center the initial item
    double initialItemWidth = _calculateItemWidth(_selectedIndex);
    offset -= (screenWidth / 2) - (initialItemWidth / 2);

    _scrollController.jumpTo(offset);
  }

  double _calculateItemWidth(int index) {
    // You can use a fixed width or calculate based on the item content.
    // Here we just return a fixed width for simplicity.
    return 60.0 +
        (widget.items[index].length *
            5); // Adjust the width based on text length
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0, // Adjust the height as needed
      margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final bool isSelected = _selectedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
              widget.onItemSelected(widget.items[index]);
            },
            child: Container(
              height: 40,
              width: _calculateItemWidth(
                  index), // Calculate the width based on the text
//              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
              margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey[900]!,
                borderRadius: BorderRadius.circular(10.0),
                //border: Border.all(
                //  color: isSelected ? Colors.blueAccent : Colors.grey[800]!,
                //  width: 0.0,
                //),
              ),
              child: Center(
                child: Text(
                  widget.items[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
