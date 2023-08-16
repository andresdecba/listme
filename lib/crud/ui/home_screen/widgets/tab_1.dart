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
                collapsedIconColor: Colors.grey, //cerrado
                iconColor: Colors.deepOrange, // abiertop
                collapsedShape: Border(bottom: BorderSide(color: Colors.grey.shade200)), //cerrado
                shape: Border(bottom: BorderSide(color: Colors.grey.shade200)), // abiertop
                subtitle: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    '${listas.length} listas',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),

                // HEAD //
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // add btn //
                    IconButton(
                      onPressed: () {
                        createNewList(categId: currentCategory.id);
                        Future.delayed(const Duration(milliseconds: 400)).then(
                          (value) => setState(() => currentCategory.isExpanded = true),
                        );
                      },
                      icon: const Icon(
                        Icons.add_circle,
                        color: Colors.black,
                      ),
                    ),

                    // title txt //
                    Expanded(
                      child: BuildTitle(
                        initialValue: currentCategory.name,
                        regularModeStyle: style.titleMedium!.copyWith(color: Colors.black),
                        editModeStyle: style.titleMedium!.copyWith(color: Colors.grey),
                        centerTxt: false,
                        onEditingComplete: (value) {
                          setState(() {
                            // currentCategory.name = value;
                            // currentCategory.save()
                            //_dbList.title = value;
                            //_dbList.save();
                          });
                        },
                      ),
                    ),
                  ],
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

class _EmptyCategory extends StatelessWidget {
  const _EmptyCategory();

  @override
  Widget build(BuildContext context) {
    final TextTheme style = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      width: double.infinity,
      child: Text(
        'No hay listas',
        style: style.bodyMedium!.copyWith(color: Colors.grey),
      ),
    );
  }
}
