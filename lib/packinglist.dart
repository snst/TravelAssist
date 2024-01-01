
import 'package:hive/hive.dart';
part 'packinglist.g.dart';


@HiveType(typeId: 0)
enum PackingListItemStateFilterEnum {
  @HiveField(0)
  all,
  @HiveField(1)
  skipped,
  @HiveField(2)
  missing,
  @HiveField(3)
  packed
}


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
class PackingListItem {
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
}

@HiveType(typeId: 3)
class PackingList {
  PackingList(this.name);

  @HiveField(0)
  String name;
  @HiveField(1)
  List<PackingListItem> items = [];
  @HiveField(2)
  PackingListItemStateFilterEnum stateFilter = PackingListItemStateFilterEnum.all;
}