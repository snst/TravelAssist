import 'package:hive/hive.dart';
part 'packinglist.g.dart';

@HiveType(typeId: 1)
enum PackingListItemStateEnum {
  @HiveField(0)
  missing,
  @HiveField(1)
  skipped,
  @HiveField(2)
  packed;
}

@HiveType(typeId: 2)
class PackingListItem extends HiveObject {
  PackingListItem(
      {this.name = "",
      this.quantity = 0,
      this.used = 0,
      this.state = PackingListItemStateEnum.missing,
      this.category = "",
      this.comment = ""});

  @HiveField(0)
  String name;
  @HiveField(1)
  String category;
  @HiveField(2)
  String comment;
  @HiveField(3)
  int quantity;
  @HiveField(4)
  int used;
  @HiveField(5)
  PackingListItemStateEnum state;

  PackingListItem clone() {
    return PackingListItem(
        name: name,
        quantity: quantity,
        used: used,
        state: state,
        category: category,
        comment: comment);
  }

  PackingListItem.copy(PackingListItem other)
      : name = other.name,
        state = other.state,
        quantity = other.quantity,
        used = other.used,
        category = other.category,
        comment = other.comment;

  void update(PackingListItem other) {
    name = other.name;
    quantity = other.quantity;
    used = other.used;
    state = other.state;
    category = other.category;
    comment = other.comment;
  }
}