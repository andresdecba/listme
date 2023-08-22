import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/crud/data/crud_use_cases.dart';
import 'package:listme/crud/models/folder.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/home_screen/widgets/category_tile.dart';
import 'package:listme/crud/ui/shared_widgets/initial_loading.dart';

class TabFolders extends StatefulWidget {
  const TabFolders({
    super.key,
  });

  @override
  State<TabFolders> createState() => _TabFoldersState();
}

class _TabFoldersState extends State<TabFolders> {
  bool isLoading = true;
  late CrudUseCases _crudUseCases;
  late Box<Folder> _categoryDb;
  late Box<Lista> _listaDb;

  @override
  void initState() {
    super.initState();
    _crudUseCases = CrudUseCasesImpl();
    _categoryDb = Hive.box<Folder>(AppConstants.categoriesDb);
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
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          //
          // HEADER OR SOMETHING //
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            child: Expanded(
              child: Text(
                'Here you can create folders to organize your lists, tap "+" to add one.',
                textAlign: TextAlign.center,
                style: style.titleSmall!.copyWith(color: Colors.grey.shade400),
              ),
            ),
          ),

          // LISTENABLE DE LAS CATEGORIAS //
          ValueListenableBuilder(
            valueListenable: _categoryDb.listenable(),
            builder: (context, Box<Folder> value, child) {
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

              // A - iterar las categorias //
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: value.values.length,
                itemBuilder: (context, index) {
                  Folder category = value.values.toList()[index];
                  List<Lista> listas = _crudUseCases.getListsFromCategoy(categId: category.id);
                  ExpansionTileController ctlr = ExpansionTileController();
                  bool isExpanded = category.isExpanded;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: ExpansionTile(
                        key: ValueKey(category.id),
                        controller: ctlr,
                        initiallyExpanded: category.isExpanded,
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: EdgeInsets.zero,
                        collapsedShape: const Border(bottom: BorderSide.none), //cerrado
                        shape: const Border(bottom: BorderSide.none), // abiertop
                        backgroundColor: Colors.grey.shade200,
                        collapsedBackgroundColor: Colors.grey.shade200,
                        onExpansionChanged: (value) {
                          category.isExpanded = value;
                          category.save();
                        },

                        // branch icon
                        leading: isExpanded
                            ? const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Icon(
                                  Icons.folder_open,
                                  color: Colors.orange,
                                ),
                              )
                            : const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Icon(
                                  Icons.folder,
                                  color: Colors.orange,
                                ),
                              ),

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

                        children: [
                          // si no hay ninguna categoria
                          if (category.listasIds.isEmpty)
                            Container(
                              height: 56,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                              color: Colors.grey.shade300,
                              child: const Text(
                                'There are no lists here :(',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),

                          // LISTENABLE DE LAS LISTAS //
                          ValueListenableBuilder(
                            valueListenable: _listaDb.listenable(),
                            builder: (context, value, child) {
                              // B - iterar las listas dentro de las categorias (lista animada) //
                              return ImplicitlyAnimatedList<Lista>(
                                items: listas,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                areItemsTheSame: (a, b) => a.id == b.id,

                                // when add lista
                                itemBuilder: (context, animation, item, i) {
                                  var isBottom = i == (listas.length - 1);

                                  return SizeFadeTransition(
                                    sizeFraction: 0.7,
                                    curve: Curves.easeInOut,
                                    animation: animation,
                                    child: CategoryTile(
                                      key: ValueKey(item.id),
                                      isBottom: isBottom,
                                      lista: item,
                                      onRemove: () {
                                        _crudUseCases.deleteLista(
                                          listaId: item.id,
                                          globalKey: AppConstants.homeScaffoldKey,
                                          onDelete: () {},
                                        );
                                      },
                                    ),
                                  );
                                },

                                // when remove lista
                                removeItemBuilder: (context, animation, oldItem) {
                                  var isBottom = listas.indexOf(oldItem) == (listas.length - 1);
                                  return FadeTransition(
                                      opacity: animation,
                                      child: CategoryTile(
                                        key: ValueKey(oldItem.id),
                                        isBottom: isBottom,
                                        lista: oldItem,
                                        onRemove: () {},
                                      ));
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  void onTapOption(_MenuOptions value, Folder category) {
    if (value == _MenuOptions.changeName) {
      _crudUseCases.changeFolderName(
        folder: category,
        folderName: category.name,
        context: context,
      );
    }
    if (value == _MenuOptions.delete) {
      _crudUseCases.deleteFolder(
        folderId: category.id,
        folderName: category.name,
        context: context,
      );
    }
    if (value == _MenuOptions.createList) {
      _crudUseCases.createNewList(
        folderId: category.id,
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
