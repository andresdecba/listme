import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/crud/data/crud_use_cases.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/shared_widgets/custom_percent_indicator.dart';

class CrudDrawerPageUno extends StatelessWidget {
  CrudDrawerPageUno({
    required this.lista,
    required this.pageCtlr,
    super.key,
  });

  final Lista lista;
  final PageController pageCtlr;
  final CrudUseCases useCases = CrudUseCasesImpl();
  final GlobalKey<ScaffoldState> crudKey = AppConstants.crudScaffoldKey;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // INDICATOR //
          Container(
            height: 150,
            alignment: Alignment.center,
            child: CustomPercentIndicator(
              lista: lista,
              size: CustomPercentIndicatorSize.big,
            ),
          ),
          // SELECT ALL //
          DrawerTile(
            texto: 'Select all',
            border: const Border(
              bottom: BorderSide(color: Colors.cyan),
            ),
            onTap: () => selectAll(context),
          ),
          // UNSELECT ALL //
          DrawerTile(
            texto: 'Uselect all',
            border: const Border(
              bottom: BorderSide(color: Colors.cyan),
            ),
            onTap: () => unselectAll(context),
          ),
          // DELETE LIST //
          DrawerTile(
            texto: 'Delete this list',
            border: const Border(
              bottom: BorderSide(color: Colors.cyan),
            ),
            onTap: () => deleteThisList(context),
          ),
          // CHANGE CATEGORY //
          DrawerTile(
            texto: 'Change category',
            onTap: () => pageCtlr.animateToPage(
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            ),
          ),
        ],
      ),
    );
  }

  // logica
  void selectAll(BuildContext context) {
    // TODO PONER UN EMERGENTE DE FELICITACIONES
    for (var element in lista.items) {
      if (!element.isCategory) {
        element.isDone = true;
      }
    }
    lista.isCompleted = true;
    lista.save();
    Future.delayed(AppConstants.initialLoadingDuration).then(
      (value) => context.pop(),
    );
  }

  void unselectAll(BuildContext context) {
    for (var element in lista.items) {
      if (!element.isCategory) {
        element.isDone = false;
      }
    }
    lista.save();
    Future.delayed(AppConstants.initialLoadingDuration).then(
      (value) => context.pop(),
    );
  }

  void deleteThisList(BuildContext context) {
    context.pop(); // cerrar del drawer
    useCases.deleteLista(
      listaId: lista.id,
      globalKey: AppConstants.homeScaffoldKey,
      onDelete: () {
        crudKey.currentContext!.pop(); // volver al home
      },
    );
  }
}

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    required this.texto,
    required this.onTap,
    this.leading,
    this.border,
    super.key,
  });

  final String texto;
  final VoidCallback onTap;
  final BoxBorder? border;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final TextTheme style = Theme.of(context).textTheme;
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          border: border,
        ),
        child: Row(
          children: [
            leading != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: leading,
                  )
                : const SizedBox.shrink(),
            Expanded(
              child: Text(
                texto,
                style: style.titleSmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
