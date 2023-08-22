import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/crud/data/crud_use_cases.dart';
import 'package:listme/crud/models/list_category.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/home_screen/widgets/category_tile.dart';
import 'package:listme/crud/ui/shared_widgets/initial_loading.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({
    super.key,
  });

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  bool isLoading = true;
  late CrudUseCases _crudUseCases;
  late Box<Category> _categoryDb;
  late Box<Lista> _listaDb;

  @override
  void initState() {
    super.initState();
    _crudUseCases = CrudUseCasesImpl();
    _categoryDb = Hive.box<Category>(AppConstants.categoriesDb);
    _listaDb = Hive.box<Lista>(AppConstants.listasDb);

    Future.delayed(AppConstants.initialLoadingDuration).then((value) => setState(() {
          isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme style = Theme.of(context).textTheme;

    // LOADER //
    if (isLoading) {
      return const InitialLoading();
    }

    // LISTENEABLE DE LAS CATEGORIAS //
    return Column(
      children: [
        //
        // HEADER OR SOMETHING //
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: Expanded(
            child: Text(
              'Here you can create categories to organize your lists, tap "+" to add one.',
              textAlign: TextAlign.center,
              style: style.titleSmall!.copyWith(color: Colors.grey.shade400),
            ),
          ),
        ),

        // LISTA DE LISTAS //
        ValueListenableBuilder(
          valueListenable: _categoryDb.listenable(),
          builder: (context, Box<Category> value, child) {
            //List<ListCategory> categories = value.values.toList();

            //  EMPTY SCREEN //
            // TODO si no hay categorias poner una imagen svg
            if (value.values.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text("No categories"),
                ),
              );
            }

            // RENDER WIDGET //
            return Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: value.values.length,
                itemBuilder: (context, index) {
                  Category category = value.values.toList()[index];
                  List<Lista> listas = _crudUseCases.getListsFromCategoy(categId: category.id);
                  ExpansionTileController ctlr = ExpansionTileController();

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: ExpansionTile(
                        key: ValueKey(category.id),
                        controller: ctlr,
                        initiallyExpanded: category.isExpanded,
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: EdgeInsets.zero,
                        collapsedShape: const Border(
                          bottom: BorderSide.none,
                        ), //cerrado
                        shape: const Border(
                          bottom: BorderSide.none,
                        ), // abiertop
                        backgroundColor: Colors.grey.shade200,
                        collapsedBackgroundColor: Colors.grey.shade200,
                        onExpansionChanged: (value) {
                          category.isExpanded = value;
                          category.save();
                        },

                        // branch icon
                        leading: category.listasIds.isEmpty ? const _EmptyBranch() : const _Branch(),

                        // titulo de la categoria
                        title: Row(
                          children: [
                            Text(
                              category.name,
                              style: style.titleMedium!.copyWith(color: Colors.black),
                            ),
                          ],
                        ),

                        // menú de opciones
                        trailing: PopupMenuButton(
                          padding: EdgeInsets.zero,
                          onSelected: (value) => onTapOption(value, category),
                          iconSize: 26,
                          color: Colors.grey.shade200,
                          position: PopupMenuPosition.under,
                          icon: const Icon(
                            Icons.more_vert_rounded,
                            color: Colors.grey,
                          ),
                          itemBuilder: (context) {
                            return [
                              menuOpts(
                                value: _MenuOptions.delete,
                                icon: Icons.delete_forever,
                                title: const Text('Delete category'),
                              ),
                              menuOpts(
                                value: _MenuOptions.changeName,
                                icon: Icons.edit,
                                title: const Text('Change category name'),
                              ),
                              menuOpts(
                                value: _MenuOptions.createList,
                                icon: Icons.add_circle_rounded,
                                title: const Text('Create a new list'),
                              ),
                            ];
                          },
                        ),

                        // LISTENABLE DE LAS LISTAS DE LA [currentCateg] //
                        children: [
                          // empty category
                          if (category.listasIds.isEmpty)
                            Container(
                              height: 56,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                              child: const Text(
                                'There are no lists here :(',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),

                          // iterar listas
                          ValueListenableBuilder(
                            valueListenable: _listaDb.listenable(),
                            builder: (context, value, child) {
                              // construir la lista de Listas //
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                //padding: const EdgeInsets.symmetric(horizontal: 10),
                                itemCount: listas.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var isBottom = index == (listas.length - 1);

                                  ///
                                  Lista element = listas[index];
                                  return CategoryTile(
                                    key: ValueKey(element.id),
                                    isBottom: isBottom,
                                    lista: element,
                                    onRemove: () {
                                      _crudUseCases.deleteLista(
                                        listaId: element.id,
                                        globalKey: AppConstants.homeScaffoldKey,
                                        onDelete: () {},
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  void onTapOption(_MenuOptions value, Category category) {
    if (value == _MenuOptions.changeName) {
      _crudUseCases.changeCategoryName(
        category: category,
        categoryName: category.name,
        context: context,
      );
    }
    if (value == _MenuOptions.delete) {
      _crudUseCases.deleteCategory(
        categoryId: category.id,
        categoryName: category.name,
        context: context,
      );
    }
    if (value == _MenuOptions.createList) {
      _crudUseCases.createNewList(
        categoryId: category.id,
        context: context,
      );
    }
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

enum _MenuOptions { changeName, delete, createList }

class _EmptyBranch extends StatelessWidget {
  const _EmptyBranch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: 20,
      //color: Colors.yellow,
      margin: const EdgeInsets.only(left: 10),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 12,
              width: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Branch extends StatelessWidget {
  const _Branch({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: 20,
      //color: Colors.yellow,
      margin: const EdgeInsets.only(left: 10),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 25,
              width: 2,
              margin: const EdgeInsets.only(left: 5),
              color: Colors.orange,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 12,
              width: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
