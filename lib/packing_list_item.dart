import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum PackingListItemStateEnum {
  todo,
  skipped,
  packed;
}

final List<IconData> CategoryIcons = [
  FontAwesomeIcons.shirt,
  FontAwesomeIcons.socks,
  FontAwesomeIcons.suitcaseMedical,
  FontAwesomeIcons.headphones,
  FontAwesomeIcons.cookieBite,
  FontAwesomeIcons.creditCard,
  FontAwesomeIcons.book,
  FontAwesomeIcons.volleyball,
  FontAwesomeIcons.binoculars,
  FontAwesomeIcons.pumpSoap,
];


class PackingListItem {
  PackingListItem(
      {this.name = "",
      this.quantity = 0,
      this.used = 0,
      this.state = PackingListItemStateEnum.todo,
      this.category = "",
      this.comment = "",
      this.categoryItem=0});
  String name;
  String category;
  String comment;
  int quantity;
  int used;
  PackingListItemStateEnum state;
  int categoryItem;

  PackingListItem clone() {
    return PackingListItem(
        name: name,
        quantity: quantity,
        used: used,
        state: state,
        category: category,
        comment: comment,
        categoryItem:categoryItem);
  }

  PackingListItem.copy(PackingListItem other)
      : name = other.name,
        state = other.state,
        quantity = other.quantity,
        used = other.used,
        category = other.category,
        comment = other.comment,
        categoryItem = other.categoryItem;
}
