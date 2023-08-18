import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listme/core/routes/routes.dart';
import 'package:listme/crud/data/local_storage_datasource.dart';
import 'package:listme/crud/models/list_category.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/shared_widgets/custom_bottomsheet.dart';
import 'package:listme/crud/ui/shared_widgets/input_item.dart';

abstract class CrudUseCases {
  void createNewList({
    String? categoryId,
    String? colorScheme,
    bool navigate = true,
    required BuildContext context,
  });

  void changeCategoryName({
    required ListCategory category,
    required String categoryName,
    required BuildContext context,
  });

  void deleteCategory({
    required String categoryId,
    required String categoryName,
    required BuildContext context,
  });

  void deleteLista({
    required String listaId,
  });

  List<Lista> getListsFromCategoy({
    required String categId,
  }); // obtener las listas asociadas a una categoria

  String createNewCategory({
    required BuildContext context,
  });
}

class CrudUseCasesImpl extends CrudUseCases {
  final LocalStorageDatasource _dataSource = LocalStorageDatasourceImpl();

  // CREAR UNA LISTA NUEVA //
  @override
  void createNewList({
    String? categoryId,
    String? colorScheme,
    bool navigate = true,
    required BuildContext context,
  }) {
    var listaId = '';
    customBottomSheet(
      context: context,
      showClose: true,
      enableDrag: true,
      onClose: () {},
      title: 'Create a new list',
      child: CustomTextfield(
        onTap: () {},
        onEditingComplete: (value) async {
          // crear lista
          listaId = _dataSource.createNewList(
            listName: value,
            category: categoryId,
            colorScheme: colorScheme,
          );
          // esperar para que se vea la animacion en la lista y navegar
          if (navigate) {
            await Future.delayed(const Duration(milliseconds: 600)).then((value) {
              context.pushNamed(AppRoutes.crudScreen, extra: listaId);
            });
          }
        },
      ),
    );
  }

  // CAMBIARLE EL NOMBRE A LA CATEGORIA //
  @override
  void changeCategoryName({
    required ListCategory category,
    required String categoryName,
    required BuildContext context,
  }) {
    customBottomSheet(
      context: context,
      showClose: true,
      enableDrag: true,
      onClose: () {},
      title: 'Change category name',
      subTitle: '"$categoryName"',
      child: CustomTextfield(
        onTap: () {},
        hintText: 'New category name',
        onEditingComplete: (value) {
          _dataSource.changeCategoryName(
            newValue: value,
            categId: category.id,
          );
        },
      ),
    );
  }

  // BORRAR UNA CATEGORÍA //

  @override
  void deleteCategory({
    required String categoryId,
    required String categoryName,
    required BuildContext context,
  }) {
    customBottomSheet(
      context: context,
      showClose: true,
      enableDrag: true,
      onClose: () {},
      title: 'Delete category',
      subTitle: '"$categoryName"',
      child: Column(
        children: [
          // BORRAR CATEGORIA //
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                _dataSource.deleteCategory(categId: categoryId);
                context.pop();
              },
              child: const Text('Borrar sólo la categoria'),
            ),
          ),

          // BORRAR TODITO //
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                _dataSource.deleteCategory(categId: categoryId, deleteLists: true);
                context.pop();
              },
              child: const Text('Borrar la categoria y todas sus listas'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  void deleteLista({required String listaId}) {
    // TODO poner un emergente
    _dataSource.deleteLista(listId: listaId);
  }

  @override
  List<Lista> getListsFromCategoy({required String categId}) {
    return _dataSource.getListsFromCategoy(categId: categId);
  }

  @override
  String createNewCategory({
    required BuildContext context,
  }) {
    var value = '';
    customBottomSheet(
      context: context,
      showClose: true,
      enableDrag: true,
      onClose: () {},
      title: 'Create a new category',
      child: CustomTextfield(
        hintText: 'Category name',
        onTap: () {},
        onEditingComplete: (value) {
          value = _dataSource.createNewCategory(
            categoryName: value,
          );
        },
      ),
    );
    return value;
  }
}
