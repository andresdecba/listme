import 'package:hive/hive.dart';
import 'package:listme/crud/models/item.dart';
part 'lista.g.dart';

// flutter packages pub run build_runner build

@HiveType(typeId: 1)
class Lista extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  DateTime creationDate;
  @HiveField(2)
  List<Item> items;
  @HiveField(3)
  String id;
  @HiveField(4)
  String? colorSchemeId;
  @HiveField(5)
  String? categoryId;
  @HiveField(6)
  bool isCompleted;

  Lista({
    required this.title,
    required this.creationDate,
    required this.items,
    required this.id,
    required this.isCompleted,
    this.categoryId,
    this.colorSchemeId,
  });

  Lista copyWith({
    required String title,
    required DateTime creationDate,
    required List<Item> items,
    required String id,
    required bool isCompleted,
    String? category,
    String? colorScheme,
  }) {
    return Lista(
      id: id,
      title: title,
      creationDate: creationDate,
      items: items,
      categoryId: category,
      isCompleted: isCompleted,
    );
  }

  @override
  String toString() {
    return 'id: $id, title: $title, creationDate $creationDate, items: $items, category $categoryId, isCompleted $isCompleted';
  }
}








/*


class Item {
  String content;
  bool isDone;
  String id;
  Item({
    required this.content,
    required this.isDone,
    required this.id,
  });

  @override
  String toString() {
    return '$content, $isDone';
  }
}





Uuid _uuid = const Uuid();

class Lista {
  String title;
  DateTime creationDate;
  List<Item> items;
  String id = _uuid.v4();

  Lista({
    required this.title,
    required this.creationDate,
    required this.items,
  });

  @override
  String toString() {
    return 'id: $id, title: $title, items: $items';
  }
}

class Item {
  String content;
  bool isDone;
  String id = _uuid.v4();
  Item({
    required this.content,
    required this.isDone,
  });

  @override
  String toString() {
    return '$content, $isDone';
  }
}


*/