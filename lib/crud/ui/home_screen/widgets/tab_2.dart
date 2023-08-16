import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/home_screen/widgets/list_tile.dart';

// MUESTRA TODAS LAS LISTAS EN TAB-2 "My lists" //

class TabDos extends StatefulWidget {
  const TabDos({
    super.key,
  });

  @override
  State<TabDos> createState() => _TabDosState();
}

class _TabDosState extends State<TabDos> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 350)).then((value) => setState(() {
          isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    // LOADER //
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.cyan,
        ),
      );
    }

    // RENDER LISTA //
    return ValueListenableBuilder(
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
        return ImplicitlyAnimatedList<Lista>(
          shrinkWrap: true,
          items: listas,
          areItemsTheSame: (a, b) => a.id == b.id,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),

          // add
          itemBuilder: (context, animation, item, index) {
            return SizeFadeTransition(
              sizeFraction: 0.7,
              curve: Curves.easeInOut,
              animation: animation,
              child: CustomListTile(
                lista: item,
                onRemove: () => item.delete(),
              ),
            );
          },

          // remove
          removeItemBuilder: (context, animation, oldItem) {
            return FadeTransition(
              opacity: animation,
              child: CustomListTile(
                lista: oldItem,
                onRemove: () {},
              ),
            );
          },
        );
      },
    );
  }
}
