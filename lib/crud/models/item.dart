import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'item.g.dart';

// flutter packages pub run build_runner build

@HiveType(typeId: 2)
class Item {
  @HiveField(0)
  String content;
  @HiveField(1)
  bool isDone;
  @HiveField(2)
  String id;
  @HiveField(3)
  bool isCategory;
  GlobalKey? key;

  Item({
    required this.content,
    required this.isDone,
    required this.id,
    required this.isCategory,
    this.key,
  });

  Item copyWith({
    required String content,
    required bool isDone,
    required String id,
    required bool isCategory,
  }) {
    return Item(
      content: content,
      isDone: isDone,
      id: id,
      isCategory: isCategory,
    );
  }

  @override
  String toString() {
    return '$id, $content, $isDone, $isCategory';
  }
}
