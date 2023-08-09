import 'package:isar/isar.dart';
import 'package:listme/crud/models/item_list.dart';
import 'package:path_provider/path_provider.dart';

abstract class LocalStorageDatasource {
  Future<void> setItemList(ItemList itemList);
  Future<ItemList> getItemList(int id);
  Future<List<ItemList>> getAllItemList();
  Future<void> deleteItemList(int id);
  Future<void> updateItemList(ItemList itemList);
}

class LocalStorageDatasourceImpl extends LocalStorageDatasource {
  LocalStorageDatasourceImpl() {
    db = openDB();
  }

  // open Isar in the constructor
  late Future<Isar> db;
  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [ItemListSchema],
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  @override
  Future<void> setItemList(ItemList itemList) async {
    final isar = await db;

    isar.writeTxn(() => isar.itemLists.put(itemList));
  }

  @override
  Future<ItemList> getItemList(int id) async {
    final isar = await db;
    final result = await isar.itemLists.get(id);
    print('holis from dataSource: $result');
    return result!;
  }

  @override
  Future<void> deleteItemList(int id) async {
    final isar = await db;
    await isar.itemLists.delete(id);
  }

  @override
  Future<void> updateItemList(ItemList itemList) async {
    final isar = await db;
    await isar.itemLists.put(itemList);
  }

  @override
  Future<List<ItemList>> getAllItemList() async {
    final isar = await db;
    late List<ItemList> coso;
    await isar.txn(() async {
      coso = await isar.itemLists.where().findAll();
    });
    return coso;
  }
}
