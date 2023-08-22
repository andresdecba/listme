import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/core/routes/routes.dart';
import 'package:listme/crud/data/local_storage_datasource.dart';
import 'package:listme/crud/models/folder.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/shared_widgets/custom_bottomsheet.dart';
import 'package:listme/crud/ui/shared_widgets/input_item.dart';

abstract class CrudUseCases {
  void createNewList({
    String? folderId,
    String? colorScheme,
    bool navigate = true,
    required BuildContext context,
  });

  void changeFolderName({
    required Folder folder,
    required String folderName,
    required BuildContext context,
  });

  void changeFolder({
    required String targetFolderId,
    required String listId,
  });

  void deleteFolder({
    required String folderId,
    required String folderName,
    required BuildContext context,
  });

  void deleteLista({
    required GlobalKey globalKey,
    required String listaId,
    required VoidCallback onDelete,
  });

  List<Lista> getListsFromCategoy({
    required String categId,
  }); // obtener las listas asociadas a una categoria

  Lista getList({
    required String listaId,
  });

  String createNewFolder({
    required BuildContext context,
  });

  Folder getFolder({
    required String folderId,
  });

  List<Folder> getFolders();
}

class CrudUseCasesImpl extends CrudUseCases {
  final LocalStorageDatasource _dataSource = LocalStorageDatasourceImpl();

  // CREAR UNA LISTA NUEVA //
  @override
  void createNewList({
    String? folderId,
    String? colorScheme,
    bool navigate = true,
    required BuildContext context,
  }) {
    var listaId = '';
    String? categName;
    String title = 'Create a new list';

    if (folderId != null) {
      categName = _dataSource.getFolder(folderId: folderId).name;
      title = 'Create a new list in:';
    }

    customBottomSheet(
      context: context,
      showClose: true,
      enableDrag: true,
      onClose: () {},
      title: title,
      subTitle: categName,
      child: CustomTextfield(
        onTap: () {},
        onEditingComplete: (value) async {
          // crear lista
          listaId = _dataSource.createNewList(
            listName: value,
            folder: folderId,
            colorScheme: colorScheme,
          );
          context.pop();
          // esperar para que se vea la animacion en la lista y navegar
          if (navigate) {
            await Future.delayed(const Duration(milliseconds: 700)).then((value) {
              context.pushNamed(AppRoutes.crudScreen, extra: listaId);
            });
          }
        },
      ),
    );
  }

  @override
  void changeFolder({
    required String targetFolderId,
    required String listId,
  }) {
    print('jajaja useCase');
    _dataSource.changeFolder(targetFolderId: targetFolderId, listId: listId);
  }

  // CAMBIARLE EL NOMBRE A LA CATEGORIA //
  @override
  void changeFolderName({
    required Folder folder,
    required String folderName,
    required BuildContext context,
  }) {
    customBottomSheet(
      context: context,
      showClose: true,
      enableDrag: true,
      onClose: () {},
      title: 'Change name to:',
      subTitle: '"$folderName"',
      child: CustomTextfield(
        onTap: () {},
        hintText: 'New folder name',
        onEditingComplete: (value) {
          context.pop();
          _dataSource.changeFolderName(
            newValue: value,
            folderId: folder.id,
          );
        },
      ),
    );
  }

  // BORRAR UNA CATEGORÍA //
  @override
  void deleteFolder({
    required String folderId,
    required String folderName,
    required BuildContext context,
  }) {
    customBottomSheet(
      context: context,
      showClose: true,
      enableDrag: true,
      onClose: () {},
      title: 'Delete folder:',
      subTitle: '"$folderName"',
      child: Column(
        children: [
          // borrar solamente las categporias y desasociar las listas
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                _dataSource.deleteFolder(folderId: folderId);
                context.pop();
              },
              child: const Text('Delete only the folder'),
            ),
          ),

          // borrar la categoria mas todas sus listas asociadas
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                _dataSource.deleteFolder(folderId: folderId, deleteLists: true);
                context.pop();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.warning_rounded),
                  SizedBox(width: 10),
                  Text('Delete the folder and all its lists'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // BORRAR UNA LISTA //
  @override
  void deleteLista({
    required GlobalKey globalKey, // ej: crudScaffoldKey = GlobalKey<ScaffoldState>();
    required String listaId,
    required VoidCallback onDelete,
  }) async {
    String listName = _dataSource.getList(listaId: listaId).title;

    customBottomSheet(
      context: globalKey.currentContext!,
      showClose: true,
      enableDrag: true,
      onClose: () {},
      title: 'Delete "$listName" ?',
      child: Column(
        children: [
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                globalKey.currentContext!.pop(); // cerrar el bottomSheet
                onDelete();
                _dataSource.deleteLista(listId: listaId);
              },
              child: const Text('Delete'),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // OBTENER TODAS LAS LISTAS QUE PERTENEZCAN A UNA CATEGORIA //
  @override
  List<Lista> getListsFromCategoy({required String categId}) {
    return _dataSource.getListsFromFolder(folderId: categId);
  }

  // CREATE A NEW FOLDER //
  @override
  String createNewFolder({
    required BuildContext context,
  }) {
    var value = '';
    customBottomSheet(
      context: context,
      showClose: true,
      enableDrag: true,
      onClose: () {},
      title: 'Create a new folder',
      child: CustomTextfield(
        hintText: 'folder name',
        onTap: () {},
        onEditingComplete: (value) {
          value = _dataSource.createNewFolder(
            folderName: value,
          );
          context.pop();
        },
      ),
    );
    return value;
  }

  @override
  Folder getFolder({required String folderId}) {
    return _dataSource.getFolder(folderId: folderId);
  }

  @override
  Lista getList({required String listaId}) {
    return _dataSource.getList(listaId: listaId);
  }

  @override
  List<Folder> getFolders() {
    return Helpers.sortFoldersByDateTime(
      folders: _dataSource.getFolders(),
    );
  }
}
