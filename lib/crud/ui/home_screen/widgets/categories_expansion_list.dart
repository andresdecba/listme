import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/crud/models/list_category.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/crud_screen/widgets/list_title.dart';
import 'package:listme/crud/ui/home_screen/widgets/list_tile.dart';

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
  late Box<Lista> _listasDb;

  @override
  void initState() {
    super.initState();
    _listasDb = Hive.box(AppConstants.listasDb);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme style = Theme.of(context).textTheme;

    return ExpansionPanelList(
      animationDuration: const Duration(milliseconds: 400),
      expansionCallback: (int panelIndex, bool isOpen) => setState(() {
        widget.categories[panelIndex].isExpanded = !isOpen;
      }),
      expandIconColor: Colors.deepOrange,
      elevation: 0,
      expandedHeaderPadding: const EdgeInsets.symmetric(horizontal: 15),
      dividerColor: Colors.cyan,
      children: [
        // ITERAR CATEGORIAS //
        ...widget.categories.map((e) {
          // buscar listas

          final List<Lista> listas = [];
          for (var element in e.listsIds) {
            var lista = _listasDb.get(element);
            if (lista != null) {
              listas.add(lista);
            }
          }

          return ExpansionPanel(
            isExpanded: e.isExpanded,
            canTapOnHeader: true,
            backgroundColor: Colors.white,

            // HEADER: titulo
            headerBuilder: (context, isOpen2) => Center(
              child: ListTitle(
                initialValue: e.categoryName,
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

            //  BODY: listas
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // if empty
                if (e.listsIds.isEmpty) const _EmptyCategory(),

                // iterate lists
                ...listas.map((e) {
                  int totalDone = 0;
                  int totalUndone = e.items.length;
                  for (var element in e.items) {
                    if (element.isDone) {
                      totalDone++;
                    }
                  }

                  return CustomListTile(
                    done: totalDone,
                    undone: totalUndone,
                    titleText: e.title,
                    subTitleText: Helpers.longDateFormater(e.creationDate),
                    onTap: () {},
                    onRemove: () {},
                  );
                })
              ],
            ),
          );
        }).toList(),
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
