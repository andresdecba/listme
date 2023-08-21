import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/routes/routes.dart';
import 'package:listme/crud/data/crud_use_cases.dart';
import 'package:listme/crud/models/list_category.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/shared_widgets/custom_percent_indicator.dart';
import 'package:animate_do/animate_do.dart';

class CrudDrawer extends StatelessWidget {
  CrudDrawer({
    super.key,
    required this.lista,
  });

  final Lista lista;
  final CrudUseCases useCases = CrudUseCasesImpl();

  @override
  Widget build(BuildContext context) {
    var categories = useCases.getCategories();

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: FadeIn(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                // INDICATOR //
                Container(
                  height: 150,
                  alignment: Alignment.center,
                  child: CustomPercentIndicator(
                    lista: lista,
                    size: CustomPercentIndicatorSize.big,
                  ),
                ),
                // SELECT ALL //
                ListTile(
                  visualDensity: VisualDensity.compact,
                  title: const Text('Select all'),
                  shape: const Border(
                    bottom: BorderSide(color: Colors.cyan),
                    top: BorderSide(color: Colors.cyan),
                  ),
                  onTap: () => selectAll(context),
                ),
                // UNSELECT ALL //
                ListTile(
                  visualDensity: VisualDensity.compact,
                  title: const Text('Uselect all'),
                  shape: const Border(
                    bottom: BorderSide(color: Colors.cyan),
                  ),
                  onTap: () => unselectAll(context),
                ),
                // DELETE LIST //
                ListTile(
                  visualDensity: VisualDensity.compact,
                  title: const Text('Delete this list'),
                  shape: const Border(
                    bottom: BorderSide(color: Colors.cyan),
                  ),
                  onTap: () => deleteThisList(context),
                ),

                /////////////////////////////////////
                // CHANGE CATEGORY //

                ExpansionTile(
                  title: const Text('Change category'),
                  shape: const Border(
                    bottom: BorderSide(color: Colors.cyan),
                  ),
                  collapsedShape: const Border(
                    bottom: BorderSide(color: Colors.cyan),
                  ),
                  children: [
                    FadeIn(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: categories.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            color: Colors.grey.shade400,
                            endIndent: 10,
                            indent: 25,
                            height: 0,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {},
                            child: Container(
                              alignment: Alignment.centerLeft,
                              margin: index == 0 ? const EdgeInsets.fromLTRB(0, 0, 0, 10) : const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                              //color: Colors.amber,
                              child: Expanded(
                                child: Text(
                                  categories[index].name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    /*
                    Container(
                      color: Colors.amber,
                      height: 300,
                      width: 300,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...categories.map((e) {
                              return Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.all(8),
                                color: Colors.green,
                                decoration: ,
                                child: Text(e.name),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    */
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // logica
  void selectAll(BuildContext context) {
    // TODO PONER UN EMERGENTE DE FELICITACIONES
    context.pop();
    for (var element in lista.items) {
      if (!element.isCategory) {
        element.isDone = true;
      }
    }
    lista.save();
  }

  void unselectAll(BuildContext context) {
    context.pop();
    for (var element in lista.items) {
      if (!element.isCategory) {
        element.isDone = false;
      }
    }
    lista.save();
  }

  void deleteThisList(BuildContext context) {
    context.pop();
    useCases.deleteLista(
      listaId: lista.id,
      globalKey: AppConstants.crudScaffoldKey,
      onDelete: () => context.goNamed(AppRoutes.homeScreen),
    );
  }
}

class _ChangeCategoty extends StatelessWidget {
  const _ChangeCategoty({
    required this.categories,
    super.key,
  });

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('titulo'),
      shape: const Border(
        bottom: BorderSide(color: Colors.cyan),
      ),
      children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...categories.map((e) {
                  return Container(
                    height: 100,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    color: Colors.green,
                    child: Text(e.name),
                  );
                }),
              ],
            ),
          ),
        )
      ],
    );
  }
}

/*
Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              


              Container(
                height: 100,
                color: Colors.pink,
                child: Text('categoria 1'),
              ),
              Container(
                height: 100,
                color: Colors.green,
                child: Text('categoria 2'),
              ),
              Container(
                height: 100,
                color: Colors.yellow,
                child: Text('categoria 3'),
              ),
              Container(
                height: 100,
                color: Colors.blue,
                child: Text('categoria 4'),
              ),
            ],
          )

*/