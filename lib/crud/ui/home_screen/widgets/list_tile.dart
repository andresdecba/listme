import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/core/routes/routes.dart';
import 'package:listme/crud/models/folder.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/shared_widgets/custom_percent_indicator.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.lista,
    required this.onRemove,
    // required this.titleText,
    // required this.subTitleText,
    // required this.onTap,
    // required this.done,
    // required this.undone,
    // this.bgColor,
  });

  final Lista lista;
  final VoidCallback onRemove;
  // final VoidCallback onTap;
  // final String titleText;
  // final String subTitleText;
  // final int done;
  // final int undone;
  // final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    final TextTheme style = Theme.of(context).textTheme;
    final double widthScreen = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () => context.pushNamed(AppRoutes.crudScreen, extra: lista.id),
      child: Container(
        height: 70,
        width: widthScreen,
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 10),

            // PROGRESS INDICATOR //
            CustomPercentIndicator(lista: lista),
            const SizedBox(width: 20),

            // TEXTS //
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
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
                    style: style.titleMedium,
                  ),

                  // date + categ
                  ValueListenableBuilder(
                    valueListenable: Hive.box<Folder>(AppConstants.categoriesDb).listenable(),
                    builder: (context, value, child) {
                      String subTitle = Helpers.longDateFormater(lista.creationDate);
                      if (lista.folderId != null) {
                        var ctg = value.get(lista.folderId);
                        if (ctg != null) {
                          subTitle = '${Helpers.longDateFormater(lista.creationDate)} - ${ctg.name}';
                        }
                      }
                      return Text(
                        subTitle,
                        maxLines: 1,
                        //softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: style.bodySmall!.copyWith(color: Colors.grey, fontStyle: FontStyle.italic),
                      );
                    },
                  ),
                ],
              ),
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
