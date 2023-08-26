import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/app_configs/config_model.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/crud/models/folder.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:uuid/uuid.dart';

abstract class LocalStorageDatasource {
  String createNewList({required String listName, String? folder, String? colorScheme});
  String createNewFolder({required String folderName});
  Folder getFolder({required String folderId});
  List<Lista> getListsFromFolder({required String folderId}); // obtener las listas asociadas a una categoria
  List<Folder> getFolders();
  Lista getList({required String listaId});
  void deleteLista({required String listId});
  void deleteFolder({required String folderId, bool deleteLists = false});
  void changeFolderName({required String folderId, required String newValue});
  void changeFolder({required String targetFolderId, required String listId}); // cambiar de categoría una lista
}

// TODO: hacer un manejo de los errores si por si las busquedas devuelven "null"

class LocalStorageDatasourceImpl extends LocalStorageDatasource {
  final Uuid _uuid = const Uuid();
  final Box<Lista> _listasDb = Hive.box<Lista>(AppConstants.listasDb);
  final Box<Folder> _foldersDb = Hive.box<Folder>(AppConstants.foldersDb);
  final Box<AppConfig> _configDb = Hive.box<AppConfig>(AppConstants.configDb);

  @override
  String createNewList({required String listName, String? folder, String? colorScheme}) {
    // nueva lista
    final newList = Lista(
      title: listName,
      creationDate: DateTime.now(),
      items: [],
      id: _uuid.v4(),
      folderId: folder,
      colorSchemeId: colorScheme,
      isCompleted: false,
    );
    // agregar a la db
    _listasDb.put(newList.id, newList);
    // agregar a la categoria
    if (folder != null) {
      var getCtg = _foldersDb.get(folder);
      if (getCtg != null) {
        getCtg.listasIds.add(newList.id);
        getCtg.save();
      }
    }
    return newList.id;
  }

  @override
  String createNewFolder({required String folderName}) {
    final Folder newFolder = Folder(
      name: folderName,
      isExpanded: true,
      id: _uuid.v4(),
      listasIds: [],
      creationDate: DateTime.now(),
    );
    _foldersDb.put(newFolder.id, newFolder);
    return newFolder.id;
  }

  @override
  List<Lista> getListsFromFolder({required String folderId}) {
    var categ = _foldersDb.get(folderId);
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
      if (lista.folderId != null) {
        var categ = _foldersDb.get(lista.folderId);
        if (categ != null) categ.listasIds.remove(lista.id);
        categ!.save();
      }
      lista.delete();
    }
    // setear la configuracion de la app
    if (listId == AppConstants.exampleList0Id || listId == AppConstants.exampleList1Id) {
      var coso = _configDb.get(AppConstants.configKey);
      if (coso != null) {
        coso.examplesDone = true;
        coso.save();
      }
    }
  }

  @override
  void deleteFolder({required String folderId, bool deleteLists = false}) {
    var categ = _foldersDb.get(folderId);
    for (var element in categ!.listasIds) {
      var lista = _listasDb.get(element);
      if (lista != null) {
        // desasociar categoria
        if (!deleteLists) {
          lista.folderId = null;
          lista.save();
        }
        // borrar la lista
        if (deleteLists) {
          lista.delete();
        }
      }
    }
    _foldersDb.delete(folderId);
    // setear la configuracion de la app
    if (folderId == AppConstants.exampleFolder0Id) {
      var coso = _configDb.get(AppConstants.configKey);
      if (coso != null) {
        coso.examplesDone = true;
        coso.save();
      }
    }
  }

  @override
  void changeFolderName({required String folderId, required String newValue}) {
    var categ = _foldersDb.get(folderId);
    if (categ != null) {
      categ.name = newValue;
      categ.save();
    }
  }

  @override
  void changeFolder({required String targetFolderId, required String listId}) {
    var list = _listasDb.get(listId);
    if (list != null) {
      Folder? newCateg = _foldersDb.get(targetFolderId);
      Folder? oldCateg;

      if (list.folderId != null) {
        oldCateg = _foldersDb.get(list.folderId);
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

      // 3- cambiar el folder-id en la lista
      list.folderId = targetFolderId;
      list.save();
    }
  }

  @override
  Folder getFolder({required String folderId}) {
    return _foldersDb.get(folderId)!;
  }

  @override
  Lista getList({required String listaId}) {
    return _listasDb.get(listaId)!;
  }

  @override
  List<Folder> getFolders() {
    return _foldersDb.values.toList();
  }
}
