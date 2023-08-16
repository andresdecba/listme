// import 'package:isar/isar.dart';
// import 'package:listme/crud/models/item_list.dart';
// import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/crud/models/list_category.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:uuid/uuid.dart';

abstract class LocalStorageDatasource {
  String createNewList({required String listName, String? category, String? colorScheme});
  String createNewCategory({required String categoryName});
  List<Lista> getListsOfCategory({required String categId});
}

class LocalStorageDatasourceImpl extends LocalStorageDatasource {
  final Uuid _uuid = const Uuid();
  final Box<Lista> _listasDb = Hive.box(AppConstants.listasDb);
  final Box<ListCategory> _categoriesDb = Hive.box(AppConstants.categoriesDb);

  @override
  String createNewList({required String listName, String? category, String? colorScheme}) {
    // nueva lista
    final newList = Lista(
      title: listName,
      creationDate: DateTime.now(),
      items: [],
      id: _uuid.v4(),
      category: category,
      colorScheme: colorScheme,
    );
    // agregar a la db
    _listasDb.put(newList.id, newList);

    return newList.id;
  }

  @override
  String createNewCategory({required String categoryName}) {
    final ListCategory newCategory = ListCategory(
      name: categoryName,
      isExpanded: true,
      id: _uuid.v4(),
    );

    _categoriesDb.put(newCategory.id, newCategory);
    return newCategory.id;
  }

  @override
  List<Lista> getListsOfCategory({required String categId}) {
    final List<Lista> result = [];

    for (var e in _listasDb.values) {
      if (e.category == categId) {
        result.add(e);
      }
    }

    return result;
  }
}














// abstract class LocalStorageDatasource {
//   Future<void> setItemList(ItemList itemList);
//   Future<ItemList> getItemList(int id);
//   Future<List<ItemList>> getAllItemList();
//   Future<void> deleteItemList(int id);
//   Future<void> updateItemList(ItemList itemList);
// }

// class LocalStorageDatasourceImpl extends LocalStorageDatasource {
//   LocalStorageDatasourceImpl() {
//     db = openDB();
//   }

//   // open Isar in the constructor
//   late Future<Isar> db;
//   Future<Isar> openDB() async {
//     final dir = await getApplicationDocumentsDirectory();
//     if (Isar.instanceNames.isEmpty) {
//       return await Isar.open(
//         [ItemListSchema],
//         directory: dir.path,
//       );
//     }
//     return Future.value(Isar.getInstance());
//   }

//   @override
//   Future<void> setItemList(ItemList itemList) async {
//     final isar = await db;

//     isar.writeTxn(() => isar.itemLists.put(itemList));
//   }

//   @override
//   Future<ItemList> getItemList(int id) async {
//     final isar = await db;
//     final result = await isar.itemLists.get(id);
//     print('holis from dataSource: $result');
//     return result!;
//   }

//   @override
//   Future<void> deleteItemList(int id) async {
//     final isar = await db;
//     await isar.itemLists.delete(id);
//   }

//   @override
//   Future<void> updateItemList(ItemList itemList) async {
//     final isar = await db;
//     await isar.itemLists.put(itemList);
//   }

//   @override
//   Future<List<ItemList>> getAllItemList() async {
//     final isar = await db;
//     late List<ItemList> coso;
//     await isar.txn(() async {
//       coso = await isar.itemLists.where().findAll();
//     });
//     return coso;
//   }
// }
