import 'package:uuid/uuid.dart';

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
