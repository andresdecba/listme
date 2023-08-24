import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/crud/data/crud_use_cases.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/home_screen/widgets/tile_list.dart';
import 'package:listme/crud/ui/shared_widgets/empty_screen_bg.dart';
import 'package:listme/crud/ui/shared_widgets/initial_loading.dart';

// MUESTRA TODAS LAS LISTAS EN TAB-2 "My lists" //

class TabLists extends StatefulWidget {
  const TabLists({
    super.key,
  });

  @override
  State<TabLists> createState() => _TabListsState();
}

class _TabListsState extends State<TabLists> {
  bool isLoading = true;
  late CrudUseCases _crudUseCases;
  late Box<Lista> _listaDb;

  @override
  void initState() {
    super.initState();
    _crudUseCases = CrudUseCasesImpl();
    _listaDb = Hive.box<Lista>(AppConstants.listasDb);
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

    // RENDER LISTA //
    return ValueListenableBuilder(
      valueListenable: _listaDb.listenable(),
      builder: (context, value, child) {
        List<Lista> listas = Helpers.sortListsByDateTime(listas: value.values.toList());

        return Stack(
          children: [
            FadeIn(
              child: ImplicitlyAnimatedList<Lista>(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                items: listas,
                areItemsTheSame: (a, b) => a.id == b.id,
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 80),

                // when add a new list
                itemBuilder: (context, animation, item, index) {
                  return SizeFadeTransition(
                    sizeFraction: 0.7,
                    curve: Curves.easeInOut,
                    animation: animation,
                    child: TileList(
                      lista: item,
                      onRemove: () => _crudUseCases.deleteLista(
                        listaId: item.id,
                        globalKey: AppConstants.homeScaffoldKey,
                        onDelete: () {},
                      ),
                    ),
                  );
                },

                // when remove a list
                removeItemBuilder: (context, animation, oldItem) {
                  return FadeTransition(
                    opacity: animation,
                    child: TileList(
                      lista: oldItem,
                      onRemove: () {},
                    ),
                  );
                },
              ),
            ),

            // EMPTY SCREEN //
            if (listas.isEmpty)
              const EmptyScreenBg(
                svgPath: 'assets/svg/empty-lists.svg',
                text: 'Here you can see all your lists, tap "+" to add one.',
              ),
          ],
        );
      },
    );
  }
}
