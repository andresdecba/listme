import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/routes/routes.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/home_screen/widgets/list_tile.dart';

class TabDos extends StatelessWidget {
  const TabDos({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Lista>(AppConstants.listasDb).listenable(),
      builder: (context, Box<Lista> listas, _) {
        // no lists
        if (listas.values.isEmpty) {
          return const Center(
            child: Text("No hay listas"),
          );
        }

        // lists
        return ImplicitlyAnimatedList<Lista>(
          shrinkWrap: true,
          items: listas.values.toList(),
          areItemsTheSame: (a, b) => a.id == b.id,

          //
          itemBuilder: (context, animation, item, index) {
            return SizeFadeTransition(
              sizeFraction: 0.7,
              curve: Curves.easeInOut,
              animation: animation,
              child: CustomListTile(
                titleText: item.title,
                subTitleText: "20-06-2023",
                onTap: () => context.pushNamed(AppRoutes.crudScreen, extra: item.id),
                onRemove: () {
                  item.delete();
                },
              ),
            );
          },

          //
          removeItemBuilder: (context, animation, oldItem) {
            return FadeTransition(
              opacity: animation,
              child: CustomListTile(
                titleText: oldItem.title,
                subTitleText: "20-06-2023",
                onTap: () {},
                onRemove: () {},
              ),
            );
          },
        );
      },
    );
  }
}
