import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/crud/models/list_category.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:uuid/uuid.dart';

abstract class LocalStorageDatasource {
  String createNewList({required String listName, String? category, String? colorScheme});
  String createNewCategory({required String categoryName});
  Category getCategory({required String categId});
  List<Lista> getListsFromCategoy({required String categId}); // obtener las listas asociadas a una categoria
  List<Category> getCategories();
  Lista getList({required String listaId});
  void deleteLista({required String listId});
  void deleteCategory({required String categId, bool deleteLists = false});
  void changeCategoryName({required String categId, required String newValue});
  void changeCategory({required String targetCategId, required String listId}); // cambiar de categoría una lista
}

// TODO: hacer un manejo de los errores si por si las busquedas devuelven "null"

class LocalStorageDatasourceImpl extends LocalStorageDatasource {
  final Uuid _uuid = const Uuid();
  final Box<Lista> _listasDb = Hive.box<Lista>(AppConstants.listasDb);
  final Box<Category> _categoriesDb = Hive.box<Category>(AppConstants.categoriesDb);

  @override
  String createNewList({required String listName, String? category, String? colorScheme}) {
    // nueva lista
    final newList = Lista(
      title: listName,
      creationDate: DateTime.now(),
      items: [],
      id: _uuid.v4(),
      categoryId: category,
      colorSchemeId: colorScheme,
      isCompleted: false,
    );
    // agregar a la db
    _listasDb.put(newList.id, newList);
    // agregar a la categoria
    if (category != null) {
      var getCtg = _categoriesDb.get(category);
      if (getCtg != null) {
        getCtg.listasIds.add(newList.id);
        getCtg.save();
      }
    }
    return newList.id;
  }

  @override
  String createNewCategory({required String categoryName}) {
    final Category newCategory = Category(
      name: categoryName,
      isExpanded: true,
      id: _uuid.v4(),
      listasIds: [],
      creationDate: DateTime.now(),
    );
    _categoriesDb.put(newCategory.id, newCategory);
    return newCategory.id;
  }

  @override
  List<Lista> getListsFromCategoy({required String categId}) {
    var categ = _categoriesDb.get(categId);
    List<Lista> result = [];
    if (categ != null) {
      for (var element in categ.listasIds) {
        var lista = _listasDb.get(element);
        if (lista != null) {
          result.add(lista);
        }
      }
    }
    // retornar ordenadas por fecha
    return Helpers.sortListsByDateTime(listas: result);
  }

  @override
  void deleteLista({required String listId}) {
    var lista = _listasDb.get(listId);
    if (lista != null) {
      // borra la lista de la categoria
      if (lista.categoryId != null) {
        var categ = _categoriesDb.get(lista.categoryId);
        if (categ != null) categ.listasIds.remove(lista.categoryId);
        categ!.save();
      }
      lista.delete();
    }
  }

  @override
  void deleteCategory({required String categId, bool deleteLists = false}) {
    var categ = _categoriesDb.get(categId);
    for (var element in categ!.listasIds) {
      var lista = _listasDb.get(element);
      if (lista != null) {
        // desasociar categoria
        if (!deleteLists) {
          lista.categoryId = null;
          lista.save();
        }
        // borrar la lista
        if (deleteLists) {
          lista.delete();
        }
      }
    }
    _categoriesDb.delete(categId);
  }

  @override
  void changeCategoryName({required String categId, required String newValue}) {
    var categ = _categoriesDb.get(categId);
    if (categ != null) {
      categ.name = newValue;
      categ.save();
    }
  }

  @override
  void changeCategory({required String targetCategId, required String listId}) {
    print('jajaja dataSource');

    var list = _listasDb.get(listId);

    if (list != null) {
      Category? newCateg = _categoriesDb.get(targetCategId);
      Category? oldCateg;

      if (list.categoryId != null) {
        oldCateg = _categoriesDb.get(list.categoryId);
      }

      // 1- agregar el lista-id en la categoria nva
      if (newCateg != null) {
        newCateg.listasIds.add(list.id);
        newCateg.save();
      }

      // 2- quitar el lista-id en la categoria vieja
      if (oldCateg != null) {
        oldCateg.listasIds.remove(list.id);
        oldCateg.save();
      }

      // 3- cambiar el category-id en la lista
      list.categoryId = targetCategId;
      list.save();
    }
  }

  @override
  Category getCategory({required String categId}) {
    return _categoriesDb.get(categId)!;
  }

  @override
  Lista getList({required String listaId}) {
    return _listasDb.get(listaId)!;
  }

  @override
  List<Category> getCategories() {
    return _categoriesDb.values.toList();
  }
}
