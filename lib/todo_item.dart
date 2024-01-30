import 'package:isar/isar.dart';
part 'todo_item.g.dart';

enum TodoItemStateEnum {
  open,
  skipped,
  done;
}

@collection
class TodoItem {
  TodoItem(
      {this.name = "",
      this.quantity = 0,
      this.used = 0,
      this.state = TodoItemStateEnum.open,
      this.category = "",
      this.comment = ""});

  Id id = Isar.autoIncrement;
  String name;
  String category;
  String comment;
  int quantity;
  int used;
  @enumerated
  TodoItemStateEnum state;

  TodoItem.copy(TodoItem other)
      : id = other.id,
        name = other.name,
        state = other.state,
        quantity = other.quantity,
        used = other.used,
        category = other.category,
        comment = other.comment;

  void update(TodoItem other) {
    id = other.id;
    name = other.name;
    quantity = other.quantity;
    used = other.used;
    state = other.state;
    category = other.category;
    comment = other.comment;
  }
}
