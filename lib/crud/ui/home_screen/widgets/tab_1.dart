import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/crud/data/local_storage_datasource.dart';
import 'package:listme/crud/models/list_category.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/crud_screen/widgets/build_title.dart';
import 'package:listme/crud/ui/home_screen/widgets/list_tile.dart';
import 'package:listme/crud/ui/shared_widgets/create_task_bottomsheet.dart';
import 'package:listme/crud/ui/shared_widgets/input_item.dart';

class TabUno extends StatefulWidget {
  const TabUno({
    super.key,
  });

  @override
  State<TabUno> createState() => _TabUnoState();
}

class _TabUnoState extends State<TabUno> {
  bool isLoading = true;
  late LocalStorageDatasource _datasource;
  final Box<ListCategory> categoryDb = Hive.box<ListCategory>(AppConstants.categoriesDb);
  final Box<Lista> listaDb = Hive.box<Lista>(AppConstants.listasDb);

  @override
  void initState() {
    super.initState();
    _datasource = LocalStorageDatasourceImpl();
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
      valueListenable: categoryDb.listenable(),
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
              List<Lista> getDb = _datasource.getListsOfCategory(categId: currentCategory.id);
              List<Lista> listas = Helpers.sortListsByDateTime(listas: getDb);

              return ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding: EdgeInsets.zero,
                collapsedShape: Border(bottom: BorderSide(color: Colors.grey.shade200)), //cerrado
                shape: Border(bottom: BorderSide(color: Colors.grey.shade200)), // abiertop

                // HEAD //
                // agregar nueva lista btn
                leading: IconButton(
                  onPressed: () {
                    createNewList(categId: currentCategory.id);
                    Future.delayed(const Duration(milliseconds: 400)).then(
                      (value) => setState(() => currentCategory.isExpanded = true),
                    );
                  },
                  icon: const Icon(
                    Icons.add_circle,
                    color: Colors.cyan,
                  ),
                ),

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

                // options menu
                trailing: PopupMenuButton(
                  color: Colors.grey.shade200,
                  position: PopupMenuPosition.under,
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: Colors.grey,
                  ),
                  itemBuilder: (context) {
                    return [
                      menuOpts(
                        icon: Icons.delete_forever,
                        text: 'Delete',
                        onTap: () {},
                      ),
                      menuOpts(
                        icon: Icons.edit,
                        text: 'Change name',
                        onTap: () {},
                      ),
                    ];
                  },
                ),

                // LISTENABLE DE LAS LISTAS DE LA [currentCateg] //
                children: [
                  ValueListenableBuilder(
                    valueListenable: listaDb.listenable(),
                    builder: (context, value, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // lists in [currentCateg]
                          ...listas.map((e) {
                            return CustomListTile(
                              lista: e,
                              onRemove: () => setState(() => _datasource.deleteLista(id: e.id)),
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
    required String text,
    required VoidCallback onTap,
  }) {
    return PopupMenuItem(
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text),
            Icon(icon, color: Colors.grey.shade500),
          ],
        ),
      ),
      onTap: () => onTap(),
    );
  }

  void createNewList({required String categId}) {
    customBottomSheet(
      context: context,
      showClose: true,
      enableDrag: true,
      onClose: () {},
      title: 'Add a new list',
      child: CustomTextfield(
        onTap: () => setState(() {}),
        onEditingComplete: (value) => setState(() {
          _datasource.createNewList(
            listName: value,
            category: categId,
          );
        }),
      ),
    );
  }
}
