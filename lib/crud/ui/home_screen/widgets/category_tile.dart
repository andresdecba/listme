import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/core/routes/routes.dart';
import 'package:listme/crud/models/lista.dart';

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
      child: Container(
        height: 56, // misma altura que el widget branch
        width: widthScreen,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
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
                padding: const EdgeInsets.only(right: 10),
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
      width: 25,
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
              color: Colors.grey,
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
                  width: 10,
                  color: Colors.grey,
                ),
                Container(
                  height: 10,
                  width: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
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
