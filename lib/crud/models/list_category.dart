import 'package:hive/hive.dart';
part 'list_category.g.dart';

// flutter packages pub run build_runner build

@HiveType(typeId: 3)
class ListCategory {
  ListCategory({
    required this.name,
    required this.isExpanded,
    required this.id,
  });

  @HiveField(0)
  String name;
  @HiveField(2)
  bool isExpanded;
  @HiveField(3)
  String id;

  ListCategory copyWith({
    required String name,
    required bool isExpanded,
    required String id,
  }) {
    return ListCategory(
      name: name,
      isExpanded: isExpanded,
      id: id,
    );
  }

  @override
  String toString() {
    return 'categoryName: $name, isExpanded $isExpanded, categoryId $id';
  }
}
