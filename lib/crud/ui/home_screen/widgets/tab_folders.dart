import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/crud/data/crud_use_cases.dart';
import 'package:listme/crud/models/folder.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/home_screen/widgets/tile_folder.dart';
import 'package:listme/crud/ui/shared_widgets/empty_screen_bg.dart';
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
    _categoryDb = Hive.box<Folder>(AppConstants.foldersDb);
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
    return ValueListenableBuilder(
      valueListenable: _categoryDb.listenable(),
      builder: (context, value, child) {
        var folders = _crudUseCases.getFolders();

        //return
        return Stack(
          children: [
            // FOLDERS //
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: FadeIn(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 80),
                  itemCount: folders.length,
                  itemBuilder: (context, index) {
                    Folder category = folders[index];
                    List<Lista> listas = _crudUseCases.getListsFromCategoy(categId: category.id);
                    ExpansionTileController ctlr = ExpansionTileController();
                    bool isExpanded = category.isExpanded;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
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

                          // folder icon
                          leading: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(opacity: animation, child: child);
                            },
                            child: Padding(
                              key: ValueKey(isExpanded),
                              padding: const EdgeInsets.only(left: 10),
                              child: Icon(
                                color: Colors.orange,
                                isExpanded ? Icons.folder_open : Icons.folder,
                              ),
                            ),
                          ),

                          // titulo de la categoria
                          title: Expanded(
                            child: Text(
                              category.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: style.titleMedium!.copyWith(color: Colors.black),
                            ),
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
                                  title: const Text('Delete folder'),
                                ),
                                menuOpts(
                                  value: _MenuOptions.changeName,
                                  title: const Text('Change folder name'),
                                ),
                                menuOpts(
                                  value: _MenuOptions.createList,
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
                                      child: TileFolder(
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
                                        child: TileFolder(
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
                ),
              ),
            ),

            //  EMPTY SCREEN //
            if (value.values.isEmpty)
              const EmptyScreenBg(
                svgPath: 'assets/svg/empty-folder.svg',
                text: 'Here you can create folders to organize your lists, tap "+" to add one.',
              ),
          ],
        );
      },
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
            const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

enum _MenuOptions { changeName, delete, createList }


       //  HEADER //
                // if (_categoryDb.values.isNotEmpty)
                //   Padding(
                //     padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                //     child: Expanded(
                //       child: Text(
                //         'Here you can create folders to organize your lists, tap "+" to add one.',
                //         textAlign: TextAlign.center,
                //         style: style.titleSmall!.copyWith(color: Colors.grey.shade400),
                //       ),
                //     ),
                //   ),
