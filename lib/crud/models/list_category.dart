import 'package:hive/hive.dart';
part 'list_category.g.dart';

// flutter packages pub run build_runner build

@HiveType(typeId: 3)
class ListCategory extends HiveObject {
  ListCategory({
    required this.name,
    required this.isExpanded,
    required this.id,
    required this.listasIds,
  });

  @HiveField(0)
  String name;
  @HiveField(2)
  bool isExpanded;
  @HiveField(3)
  String id;
  @HiveField(4)
  List<String> listasIds;

  ListCategory copyWith({
    required String name,
    required bool isExpanded,
    required String id,
    required List<String> listasIds,
  }) {
    return ListCategory(
      name: name,
      isExpanded: isExpanded,
      id: id,
      listasIds: listasIds,
    );
  }

  @override
  String toString() {
    return 'categoryName: $name, isExpanded $isExpanded, categoryId $id, listasIds $listasIds';
  }
}
