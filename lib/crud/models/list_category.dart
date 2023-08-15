import 'package:hive/hive.dart';
part 'list_category.g.dart';

// flutter packages pub run build_runner build

@HiveType(typeId: 3)
class ListCategory {
  ListCategory({
    required this.categoryName,
    required this.isExpanded,
    required this.categoryId,
    required this.listsIds,
  });

  @HiveField(0)
  String categoryName;
  @HiveField(1)
  List<String> listsIds;
  @HiveField(2)
  bool isExpanded;
  @HiveField(3)
  String categoryId;

  ListCategory copyWith({
    required String categoryName,
    required List<String> ids,
    required bool isExpanded,
    required String categoryId,
  }) {
    return ListCategory(
      categoryName: categoryName,
      isExpanded: isExpanded,
      categoryId: categoryId,
      listsIds: ids,
    );
  }

  @override
  String toString() {
    return 'categoryName: $categoryName, ids: $listsIds, isExpanded $isExpanded, categoryId $categoryId';
  }
}
