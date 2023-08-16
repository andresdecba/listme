import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/core/routes/routes.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.lista,
    // required this.titleText,
    // required this.subTitleText,
    // required this.onTap,
    required this.onRemove,
    // required this.done,
    // required this.undone,
    // this.bgColor,
  });

  final Lista lista;
  // final VoidCallback onTap;
  // final String titleText;
  // final String subTitleText;
  final VoidCallback onRemove;
  // final int done;
  // final int undone;
  // final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    final TextTheme style = Theme.of(context).textTheme;
    final double widthScreen = MediaQuery.of(context).size.width;

    // progress widget //
    int done = 0;
    int undone = lista.items.length;
    for (var element in lista.items) {
      if (element.isDone) {
        done++;
      }
    }
    final double percentage = (done - undone) * 100;

    return InkWell(
      onTap: () => context.pushNamed(AppRoutes.crudScreen, extra: lista.id),
      child: Container(
        height: 70,
        width: widthScreen,
        margin: const EdgeInsets.symmetric(vertical: 2),
        //padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 10),

            // PROGRESS //
            CircularPercentIndicator(
              radius: 25,
              lineWidth: 5.0,
              percent: percentage,
              center: Text(
                '$done/$undone',
                style: style.labelMedium,
              ),
              progressColor: Colors.cyan,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(width: 20),

            // TEXT //
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      lista.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: style.titleMedium,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      Helpers.longDateFormater(lista.creationDate),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: style.bodySmall!.copyWith(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.center,
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
