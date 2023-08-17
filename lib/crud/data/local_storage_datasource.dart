import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/crud/models/list_category.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:uuid/uuid.dart';

abstract class LocalStorageDatasource {
  String createNewList({required String listName, String? category, String? colorScheme});
  String createNewCategory({required String categoryName});
  List<Lista> getListsOfCategory({required String categId});
  void deleteLista({required String id});
  void deleteCategory({required String categId, bool deleteLists = false});
  void changeCategoryName({required ListCategory category, required String newValue});
}

class LocalStorageDatasourceImpl extends LocalStorageDatasource {
  final Uuid _uuid = const Uuid();
  final Box<Lista> _listasDb = Hive.box<Lista>(AppConstants.listasDb);
  final Box<ListCategory> _categoriesDb = Hive.box<ListCategory>(AppConstants.categoriesDb);

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
    _listasDb.put(newList.id, newList).then((value) => print('createNewList'));
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
    // retornar ordenadas por fecha
    return Helpers.sortListsByDateTime(listas: result);
  }

  @override
  void deleteLista({required String id}) {
    _listasDb.delete(id);
  }

  @override
  void deleteCategory({required String categId, bool deleteLists = false}) {
    // borrar solo la categoria
    if (!deleteLists) {
      for (var e in _listasDb.values) {
        if (e.category == categId) {
          e.category = null;
          e.save();
        }
      }
      _categoriesDb.delete(categId);
    }
    // borrar todo
    if (deleteLists) {
      for (var e in _listasDb.values) {
        if (e.category == categId) {
          e.delete();
        }
      }
      _categoriesDb.delete(categId);
    }
  }

  @override
  void changeCategoryName({required ListCategory category, required String newValue}) {
    category.name = newValue;
    category.save();
  }
}
