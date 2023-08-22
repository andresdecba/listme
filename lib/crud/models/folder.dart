import 'package:hive/hive.dart';
part 'folder.g.dart';

// flutter packages pub run build_runner build

@HiveType(typeId: 3)
class Folder extends HiveObject {
  Folder({
    required this.name,
    required this.isExpanded,
    required this.id,
    required this.listasIds,
    required this.creationDate,
  });

  @HiveField(0)
  String name;
  @HiveField(1)
  DateTime creationDate;
  @HiveField(2)
  bool isExpanded;
  @HiveField(3)
  String id;
  @HiveField(4)
  List<String> listasIds;

  Folder copyWith({
    required String name,
    required bool isExpanded,
    required String id,
    required List<String> listasIds,
    required DateTime creationDate,
  }) {
    return Folder(
      name: name,
      isExpanded: isExpanded,
      id: id,
      listasIds: listasIds,
      creationDate: creationDate,
    );
  }

  @override
  String toString() {
    return 'folderyName: $name, isExpanded $isExpanded, folderId $id, listasIds $listasIds';
  }
}
