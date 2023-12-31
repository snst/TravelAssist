enum PackingListItemStateEnum {
  todo,
  skipped,
  packed;
}
class PackingListItem {
  PackingListItem(
      {this.name = "",
      this.quantity = 0,
      this.used = 0,
      this.state = PackingListItemStateEnum.todo,
      this.category = "",
      this.comment = ""});
  String name;
  String category;
  String comment;
  int quantity;
  int used;
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
