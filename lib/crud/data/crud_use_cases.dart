import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listme/crud/data/local_storage_datasource.dart';
import 'package:listme/crud/models/list_category.dart';
import 'package:listme/crud/ui/shared_widgets/custom_bottomsheet.dart';
import 'package:listme/crud/ui/shared_widgets/input_item.dart';

abstract class CrudUseCases {
  void createNewList({
    String? categoryId,
    String? colorScheme,
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
}

class CrudUseCasesImpl extends CrudUseCases {
  final LocalStorageDatasource _dataSource = LocalStorageDatasourceImpl();

  // CREAR UNA LISTA NUEVA //
  @override
  void createNewList({
    String? categoryId,
    String? colorScheme,
    required BuildContext context,
  }) async {
    customBottomSheet(
      context: context,
      showClose: true,
      enableDrag: true,
      onClose: () {},
      title: 'Create a new list',
      child: CustomTextfield(
        onTap: () {},
        onEditingComplete: (value) {
          _dataSource.createNewList(
            listName: value,
            category: categoryId,
            colorScheme: colorScheme,
          );
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
            category: category,
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
    _dataSource.deleteLista(id: listaId);
  }
}
