import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/crud/data/crud_use_cases.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/home_screen/widgets/list_tile.dart';

// MUESTRA TODAS LAS LISTAS EN TAB-2 "My lists" //

class AllListsTab extends StatefulWidget {
  const AllListsTab({
    super.key,
  });

  @override
  State<AllListsTab> createState() => _AllListsTabState();
}

class _AllListsTabState extends State<AllListsTab> {
  bool isLoading = true;
  late CrudUseCases _crudUseCases;

  @override
  void initState() {
    super.initState();
    _crudUseCases = CrudUseCasesImpl();
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

    // RENDER LISTA //
    return Column(
      children: [
        //
        // HEADER OR SOMETHING //
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: Expanded(
            child: Text(
              'Here you can see all your lists,\ntap "+" to add one.',
              textAlign: TextAlign.center,
              style: style.titleSmall!.copyWith(color: Colors.grey.shade400),
            ),
          ),
        ),

        ValueListenableBuilder(
          valueListenable: Hive.box<Lista>(AppConstants.listasDb).listenable(),
          builder: (context, Box<Lista> value, _) {
            //
            List<Lista> listas = Helpers.sortListsByDateTime(listas: value.values.toList());

            // EMPTY SCREEN //
            if (listas.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text("No hay listas"),
                ),
              );
            }

            // lists
            return Expanded(
              child: ImplicitlyAnimatedList<Lista>(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                items: listas,
                areItemsTheSame: (a, b) => a.id == b.id,
                padding: const EdgeInsets.symmetric(horizontal: 10),

                // when add
                itemBuilder: (context, animation, item, index) {
                  return SizeFadeTransition(
                    sizeFraction: 0.7,
                    curve: Curves.easeInOut,
                    animation: animation,
                    child: CustomListTile(lista: item, onRemove: () => _crudUseCases.deleteLista(listaId: item.id)),
                  );
                },

                // when remove
                removeItemBuilder: (context, animation, oldItem) {
                  return FadeTransition(
                    opacity: animation,
                    child: CustomListTile(
                      lista: oldItem,
                      onRemove: () {},
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
