import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/crud/data/crud_use_cases.dart';
import 'package:listme/crud/models/list_category.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/crud_screen/widgets/drawer_page_uno.dart';
import 'package:listme/crud/ui/shared_widgets/initial_loading.dart';

class CrudDrawerPageDos extends StatefulWidget {
  const CrudDrawerPageDos({
    required this.categories,
    required this.lista,
    required this.pageCtlr,
    super.key,
  });

  final List<Category> categories;
  final Lista lista;
  final PageController pageCtlr;

  @override
  State<CrudDrawerPageDos> createState() => _CrudDrawerPageDosState();
}

class _CrudDrawerPageDosState extends State<CrudDrawerPageDos> {
  bool isLoading = true;
  late CrudUseCases useCases;
  final _duration300 = const Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    useCases = CrudUseCasesImpl();
    Future.delayed(AppConstants.initialLoadingDuration).then((value) => setState(() {
          isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    // LOADER //
    if (isLoading) {
      return const InitialLoading();
    }

    return Column(
      children: [
        // TITLO
        Container(
          height: 150,
          alignment: Alignment.center,
          child: const Text('Change category options'),
        ),

        // SI NO HAY CATEGORIAS
        if (widget.categories.isEmpty)
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.3,
            child: const Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'There are no categories.\nYou can add some, from categories section.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

        // LISTA DE CATEGORIAS //
        FadeIn(
            child: ValueListenableBuilder(
          valueListenable: Hive.box<Category>(AppConstants.categoriesDb).listenable(),
          builder: (context, value, child) {
            return ListView.separated(
              shrinkWrap: true,
              itemCount: widget.categories.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Colors.grey.shade400,
                  height: 0,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                var isTheLastTile = index == (widget.categories.length - 1);
                var targetCategId = widget.categories[index].id;
                var isCurrent = widget.categories[index].id == widget.lista.categoryId;

                // Categoria actual de la lista

                return DrawerTile(
                  texto: widget.categories[index].name,
                  border: isTheLastTile
                      ? null
                      : const Border(
                          bottom: BorderSide(color: Colors.cyan),
                        ),
                  onTap: () {
                    useCases.changeCategory(
                      targetCategId: targetCategId,
                      listId: widget.lista.id,
                    );
                    Future.delayed(AppConstants.initialLoadingDuration).then((value) => context.pop());
                  },
                  leading: AnimatedSwitcher(
                    duration: _duration300,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: isCurrent
                        ? Icon(
                            key: ValueKey(widget.lista.categoryId),
                            Icons.check_box_rounded,
                            color: Colors.cyan,
                          )
                        : Icon(
                            key: ValueKey(widget.lista.categoryId),
                            Icons.check_box_outline_blank_rounded,
                          ),
                  ),
                );
              },
            );
          },
        )),
      ],
    );
  }
}
