import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/core/routes/routes.dart';
import 'package:listme/crud/models/lista.dart';

class TileFolder extends StatelessWidget {
  const TileFolder({
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
      splashColor: Colors.cyan,
      child: Container(
        height: 55, // misma altura que el widget branch
        width: widthScreen,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          border: isBottom
              ? null
              : Border(
                  bottom: BorderSide(color: Colors.grey.shade400),
                ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 20,
              ),
            ),

            // TEXTS //
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // lista name
                  Text(
                    lista.title,
                    maxLines: 1,
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
            ),

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
