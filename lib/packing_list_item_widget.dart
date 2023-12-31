import 'package:flutter/material.dart';
import 'packing_list_item.dart';

class PackingListItemWidget extends StatelessWidget {
  PackingListItemWidget(
      {required this.item,
      required this.onItemChanged,
      required this.onEditItem,
      required this.editable})
      : super(key: ObjectKey(item));

  final PackingListItem item;
  final void Function(PackingListItem item) onItemChanged;
  final void Function(PackingListItem item) onEditItem;
  final bool editable;

  TextStyle? _getTextStyle(PackingListItemStateEnum state) {
    switch(state) {
      case PackingListItemStateEnum.todo:
      return const TextStyle(
      color: Colors.red,
    );
    case PackingListItemStateEnum.skipped:
    return const TextStyle(
      decoration: TextDecoration.lineThrough,
    );
    default: return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onEditItem(item);
      },
      leading: Icon(CategoryIcons[item.categoryItem]),
      title: Row(children: <Widget>[
        Expanded(
          child: Text(
            
              item.category.isNotEmpty
                  ? '${item.name} (${item.category})'
                  : item.name,
              style: _getTextStyle(
                  item.state)),
                  
        ),
        Text('${item.quantity} / ${item.used}'),
        
        if (editable)...[
          IconButton(
            iconSize: 30,
            icon: const Icon(
              Icons.hide_source,
              //color: Colors.red,
            ),
            alignment: Alignment.centerRight,
            onPressed: () {
              item.state = PackingListItemStateEnum.skipped;
              onItemChanged(item);
            },
          ),
          Checkbox(
            //checkColor: Colors.greenAccent,
            //activeColor: Colors.red,
            value: item.state == PackingListItemStateEnum.packed,
            onChanged: (value) {
              item.state = switch (item.state) {
                PackingListItemStateEnum.todo =>
                  PackingListItemStateEnum.packed,
                _ => PackingListItemStateEnum.todo
              };
              onItemChanged(item);
            },
          )],
          
        /*
          
        IconButton(
          iconSize: 30,
          icon: const Icon(
            Icons.edit,
            //color: Color.fromARGB(255, 4, 66, 182),
          ),
          alignment: Alignment.centerRight,
          onPressed: () {
            onEditItem(item);
          },
        ),*/
      ]),
    );
  }
}
