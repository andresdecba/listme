import 'package:flutter/material.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/crud/data/crud_use_cases.dart';
import 'package:listme/crud/data/local_storage_datasource.dart';
import 'package:listme/crud/models/list_category.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/crud_screen/widgets/build_title.dart';
import 'package:listme/crud/ui/home_screen/widgets/list_tile.dart';

// MUESTRA LAS LISTAS EN TAB-1 "My lists by categories" //

class CategoriesExpansionList extends StatefulWidget {
  const CategoriesExpansionList({
    required this.categories,
    super.key,
  });

  final List<Category> categories;

  @override
  State<CategoriesExpansionList> createState() => _CategoriesExpansionListState();
}

class _CategoriesExpansionListState extends State<CategoriesExpansionList> {
  late LocalStorageDatasource _datasource;
  late CrudUseCases _crudUseCases;

  @override
  void initState() {
    super.initState();
    _datasource = LocalStorageDatasourceImpl();
    _crudUseCases = CrudUseCasesImpl();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme style = Theme.of(context).textTheme;

    // TODO cambiar por un listview builder
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: [
        // ITERAR CATEGORIAS //
        ...widget.categories.map((currentCategory) {
          // obtener las listas de [currentCateg]
          var getDb = _datasource.getListsFromCategoy(categId: currentCategory.id);
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
                    _crudUseCases.createNewList(context: context, categoryId: currentCategory.id);
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
                        //_dbList.title = value;
                        //_dbList.save();
                      });
                    },
                  ),
                ),
              ],
            ),

            // ITERAR LISTAS DE LA CATEGORIA //
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // if no lists in [currentCateg]
                  if (listas.isEmpty) const _EmptyCategory(),

                  // lists in [currentCateg]
                  ...listas.map((e) {
                    return CustomListTile(
                      lista: e,
                      onRemove: () => setState(() => e.delete()),
                    );
                  }),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          );
        })
      ],
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
