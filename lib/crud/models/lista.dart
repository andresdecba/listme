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
  String? colorScheme;

  Lista({
    required this.title,
    required this.creationDate,
    required this.items,
    required this.id,
    this.colorScheme,
  });

  @override
  String toString() {
    return 'id: $id, title: $title, items: $items';
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