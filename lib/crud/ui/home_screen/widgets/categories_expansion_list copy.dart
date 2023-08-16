import 'package:flutter/material.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/crud/data/local_storage_datasource.dart';
import 'package:listme/crud/models/list_category.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/crud_screen/widgets/build_title.dart';
import 'package:listme/crud/ui/home_screen/widgets/list_tile.dart';
import 'package:listme/crud/ui/shared_widgets/create_task_bottomsheet.dart';
import 'package:listme/crud/ui/shared_widgets/input_item.dart';

// MUESTRA LAS LISTAS EN TAB-1 "My lists by categories" //

class CategoriesExpansionList extends StatefulWidget {
  const CategoriesExpansionList({
    required this.categories,
    super.key,
  });

  final List<ListCategory> categories;

  @override
  State<CategoriesExpansionList> createState() => _CategoriesExpansionListState();
}

class _CategoriesExpansionListState extends State<CategoriesExpansionList> {
  late LocalStorageDatasource _datasource;

  @override
  void initState() {
    super.initState();
    _datasource = LocalStorageDatasourceImpl();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme style = Theme.of(context).textTheme;

    // PARENT WIDGET //
    return ExpansionPanelList(
      animationDuration: const Duration(milliseconds: 400),
      expandIconColor: Colors.deepOrange,
      elevation: 0,
      expandedHeaderPadding: EdgeInsets.zero,
      dividerColor: Colors.cyan,
      expansionCallback: (int panelIndex, bool isOpen) => setState(() {
        widget.categories[panelIndex].isExpanded = !isOpen;
      }),
      children: [
        // ITERAR CATEGORIAS //
        ...widget.categories.map((currentCateg) {
          // obtener las listas de [currentCateg]
          var getDb = _datasource.getListsOfCategory(categId: currentCateg.id);
          List<Lista> listas = Helpers.sortListsByDateTime(listas: getDb);

          // crear el expandion panel de la [currentCateg]
          return ExpansionPanel(
            isExpanded: currentCateg.isExpanded,
            canTapOnHeader: true,
            backgroundColor: currentCateg.isExpanded ? Colors.grey.shade200 : Colors.grey.shade400,

            // HEADER: titulo de [currentCateg]
            headerBuilder: (context, isOpen2) => Center(
              child: Container(
                color: Colors.amber,
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        createNewList(categId: currentCateg.id);
                        Future.delayed(const Duration(milliseconds: 400)).then(
                          (value) => setState(() => currentCateg.isExpanded = true),
                        );
                      },
                      icon: const Icon(Icons.add_circle),
                    ),
                    Expanded(
                      child: BuildTitle(
                        initialValue: currentCateg.name,
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
              ),
            ),

            // BODY: iterar las listas en [currentCateg]
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // if no lists in [currentCateg]
                if (listas.isEmpty) const _EmptyCategory(),

                // lists in [currentCateg]
                ...listas.map((e) {
                  int totalDone = 0;
                  int totalUndone = e.items.length;
                  for (var element in e.items) {
                    if (element.isDone) {
                      totalDone++;
                    }
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomListTile(
                      done: totalDone,
                      undone: totalUndone,
                      titleText: e.title,
                      subTitleText: Helpers.longDateFormater(e.creationDate),
                      bgColor: Colors.white,
                      onTap: () {},
                      onRemove: () {},
                    ),
                  );
                }),
                const SizedBox(height: 10),
              ],
            ),
          );
        }).toList(),
      ],
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
