import 'package:flutter/material.dart';
import 'packinglist.dart';

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
    switch (state) {
      case PackingListItemStateEnum.missing:
        return const TextStyle(color: Colors.amber);
      case PackingListItemStateEnum.skipped:
        return const TextStyle(
          decoration: TextDecoration.lineThrough,
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: editable ? 45 : 25,
        child: ListTile(
          onTap: () {
            onEditItem(item);
          },
          minVerticalPadding: 0,
          visualDensity: VisualDensity(vertical: -4),

          //leading: Icon(CategoryIcons[item.categoryItem]),
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    item.name,
                    //style: _getTextStyle(item.state)
                  ),
                ),
                Text('${item.quantity} / ${item.used}'),
                if (editable) ...[
                  IconButton(
                    //iconSize: 30,
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
                        PackingListItemStateEnum.missing =>
                          PackingListItemStateEnum.packed,
                        _ => PackingListItemStateEnum.missing
                      };
                      onItemChanged(item);
                    },
                  )
                ],
              ]),
        ));
  }
}
