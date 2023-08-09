import 'package:isar/isar.dart';

part 'item_list.g.dart';

// cada vez que se modifique este modelo, ejecutar: flutter pub run build_runner build

@collection
class ItemList {
  String title;
  DateTime creationDate;
  Id id = Isar.autoIncrement;
  List<Item> items;

  ItemList({
    required this.title,
    required this.creationDate,
    required this.items,
  });

  // ItemList copiWith({
  //   required String title,
  //   required DateTime creationDate,
  //   required List<Item> items,
  // }) {
  //   return ItemList(
  //     title: title,
  //     creationDate: creationDate,
  //     items: items,
  //   );
  // }

  @override
  String toString() {
    return 'id: $id, title: $title, items: $items';
  }
}

@embedded
class Item {
  String content;
  bool isDone;
  Item({
    this.content = '',
    this.isDone = false,
  });

  @override
  String toString() {
    return 'content: $content, isDone: $isDone';
  }
}
