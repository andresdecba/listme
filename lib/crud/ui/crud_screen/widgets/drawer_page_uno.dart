import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/crud/data/crud_use_cases.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/shared_widgets/custom_percent_indicator.dart';
import 'package:listme/crud/ui/shared_widgets/drawer_elements.dart';

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
          // HEAD
          const DrawerHead(
            text: 'List options',
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
          // CHANGE FOLDER //
          DrawerTile(
            texto: 'Change folder',
            onTap: () => pageCtlr.animateToPage(
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            ),
          ),
          const Spacer(),
          // INDICATOR //
          Container(
            alignment: Alignment.center,
            child: CustomPercentIndicator(
              lista: lista,
              size: CustomPercentIndicatorSize.big,
            ),
          ),
          const Spacer(),
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
