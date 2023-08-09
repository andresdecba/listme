import 'package:hive/hive.dart';
part 'item.g.dart';

@HiveType(typeId: 2)
class Item {
  @HiveField(0)
  String content;
  @HiveField(1)
  bool isDone;
  @HiveField(2)
  String id;

  Item({
    required this.content,
    required this.isDone,
    required this.id,
  });

  @override
  String toString() {
    return '$id, $content, $isDone';
  }
}
