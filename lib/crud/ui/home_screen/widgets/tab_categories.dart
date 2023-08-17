import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/crud/data/local_storage_datasource.dart';
import 'package:listme/crud/data/crud_use_cases.dart';
import 'package:listme/crud/models/list_category.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/home_screen/widgets/list_tile.dart';
import 'package:listme/crud/ui/shared_widgets/custom_bottomsheet.dart';
import 'package:listme/crud/ui/shared_widgets/input_item.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({
    super.key,
  });

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  bool isLoading = true;
  late LocalStorageDatasource _datasource;
  late CrudUseCases _crudUseCases;
  late Box<ListCategory> _categoryDb;
  late Box<Lista> _listaDb;
  late LocalStorageDatasource _dataSource;

  @override
  void initState() {
    super.initState();
    _datasource = LocalStorageDatasourceImpl();
    _crudUseCases = CrudUseCasesImpl();
    _dataSource = LocalStorageDatasourceImpl();
    _categoryDb = Hive.box<ListCategory>(AppConstants.categoriesDb);
    _listaDb = Hive.box<Lista>(AppConstants.listasDb);

    Future.delayed(const Duration(milliseconds: 350)).then((value) => setState(() {
          isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme style = Theme.of(context).textTheme;

    // LOADER //
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.cyan,
        ),
      );
    }

    // LISTENEABLE DE LAS CATEGORIAS //
    return ValueListenableBuilder(
      valueListenable: _categoryDb.listenable(),
      builder: (context, Box<ListCategory> value, child) {
        List<ListCategory> categories = value.values.toList();

        //  EMPTY SCREEN //
        // TODO si no hay categorias poner una imagen svg
        if (categories.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text("No hay categorias"),
            ),
          );
        }

        // RENDER WIDGET //
        return ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            // ITERAR CATEGORIAS //
            ...categories.map((currentCategory) {
              // obtener las listas de [currentCateg]
              List<Lista> listas = _datasource.getListsOfCategory(categId: currentCategory.id);
              ExpansionTileController ctlr = ExpansionTileController();

              return ExpansionTile(
                key: ValueKey(currentCategory.id),
                tilePadding: EdgeInsets.zero,
                childrenPadding: EdgeInsets.zero,
                collapsedShape: Border(bottom: BorderSide(color: Colors.grey.shade200)), //cerrado
                shape: Border(bottom: BorderSide(color: Colors.grey.shade200)), // abiertop
                controller: ctlr,
                initiallyExpanded: currentCategory.isExpanded,
                onExpansionChanged: (value) {
                  currentCategory.isExpanded = value;
                  currentCategory.save();
                },

                // HEAD //
                // titulo de la categoria
                title: Text(
                  currentCategory.name,
                  style: style.titleMedium!.copyWith(color: Colors.black),
                ),

                // cantidad de listas
                subtitle: Text(
                  listas.length > 1 ? '${listas.length} lists' : '${listas.length} list',
                  style: const TextStyle(color: Colors.grey),
                ),

                // agregar nueva lista btn
                trailing: IconButton(
                  onPressed: () {
                    customBottomSheet(
                      context: context,
                      showClose: true,
                      enableDrag: true,
                      onClose: () {},
                      title: 'Create a new list in:',
                      subTitle: '"${currentCategory.name}"',
                      child: CustomTextfield(
                        onTap: () {},
                        onEditingComplete: (value) {
                          setState(() {
                            _dataSource.createNewList(
                              listName: value,
                              category: currentCategory.id,
                            );
                            context.pop();
                          });
                        },
                      ),
                    );
                    //_crudUseCases.createNewList(context: context, categoryId: currentCategory.id);
                    Future.delayed(const Duration(milliseconds: 400)).then((value) => ctlr.expand());
                  },
                  icon: const Icon(
                    Icons.add_circle,
                    color: Colors.cyan,
                  ),
                ),

                // options menu
                leading: PopupMenuButton(
                  onSelected: (value) {
                    if (value == _MenuOptions.onChangeName) {
                      _crudUseCases.changeCategoryName(
                        category: currentCategory,
                        categoryName: currentCategory.name,
                        context: context,
                      );
                    }
                    if (value == _MenuOptions.onDelete) {
                      _crudUseCases.deleteCategory(
                        categoryId: currentCategory.id,
                        categoryName: currentCategory.name,
                        context: context,
                      );
                    }
                  },
                  color: Colors.grey.shade200,
                  position: PopupMenuPosition.under,
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: Colors.grey,
                  ),
                  itemBuilder: (context) {
                    return [
                      menuOpts(
                        value: _MenuOptions.onDelete,
                        icon: Icons.delete_forever,
                        title: const Text('Delete category'),
                      ),
                      menuOpts(
                        value: _MenuOptions.onChangeName,
                        icon: Icons.edit,
                        title: const Text('Change category name'),
                      ),
                    ];
                  },
                ),

                // LISTENABLE DE LAS LISTAS DE LA [currentCateg] //
                children: [
                  ValueListenableBuilder(
                    valueListenable: _listaDb.listenable(),
                    builder: (context, value, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // lists in [currentCateg]
                          ...listas.map((e) {
                            return CustomListTile(
                              key: ValueKey(e.id),
                              lista: e,
                              onRemove: () => setState(() => _crudUseCases.deleteLista(listaId: e.id)),
                            );
                          }),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  )
                ],
              );
            })
          ],
        );
      },
    );
  }

  PopupMenuItem menuOpts({
    required IconData icon,
    required Widget title,
    required _MenuOptions value,
  }) {
    return PopupMenuItem(
      value: value,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            title,
            Icon(icon, color: Colors.grey.shade500),
          ],
        ),
      ),
    );
  }
}

enum _MenuOptions { onChangeName, onDelete }
