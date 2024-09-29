import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'currency.dart';
import 'todo_item.dart';
import 'transaction.dart';

mixin Storage {
  late Future<Isar?> db;

  Future<Isar?> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [CurrencySchema, TodoItemSchema, TransactionSchema],
        directory: dir.path,
        inspector: true,
      );
    }

    return Isar.getInstance();
  }
}
