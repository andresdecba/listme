import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/core/routes/routes.dart';
import 'package:listme/crud/models/list_category.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/shared_widgets/custom_percent_indicator.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.lista,
    required this.onRemove,
    required this.isBottom,
  });

  final Lista lista;
  final VoidCallback onRemove;
  final bool isBottom;

  @override
  Widget build(BuildContext context) {
    final TextTheme style = Theme.of(context).textTheme;
    final double widthScreen = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () => context.pushNamed(AppRoutes.crudScreen, extra: lista.id),
      // misma altura que el widget del branch
      child: Container(
        height: 56,
        width: widthScreen,
        decoration: const BoxDecoration(
          color: Colors.white,
          //borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // BRANCH //
            _Branch(
              isBottom: isBottom,
            ),
            const SizedBox(width: 20),

            // TEXTS //
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // lista name
                Text(
                  lista.title,
                  maxLines: 2,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: style.titleSmall,
                ),
                const SizedBox(height: 5),

                // date
                Text(
                  Helpers.longDateFormater(lista.creationDate),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: style.bodySmall!.copyWith(color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              ],
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => onRemove(), // lista.delete()
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                iconSize: 20,
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Branch extends StatelessWidget {
  const _Branch({
    required this.isBottom,
  });

  final bool isBottom;

  @override
  Widget build(BuildContext context) {
    // misma altura que el conteiner que lo contiene
    return Container(
      height: 56,
      width: 35,
      //color: Colors.yellow,
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.only(left: 5),
      child: Stack(
        children: [
          // vertical
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: isBottom ? 28 : 56,
              width: 2,
              color: Colors.orange,
            ),
          ),
          // horizontal
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 2,
                  width: 20,
                  color: Colors.orange,
                ),
                Container(
                  height: 10,
                  width: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
