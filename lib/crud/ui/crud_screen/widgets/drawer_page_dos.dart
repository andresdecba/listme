import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/crud/data/crud_use_cases.dart';
import 'package:listme/crud/models/folder.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/shared_widgets/empty_screen_bg.dart';
import 'package:listme/crud/ui/shared_widgets/initial_loading.dart';
import 'package:listme/crud/ui/shared_widgets/drawer_elements.dart';

class CrudDrawerPageDos extends StatefulWidget {
  const CrudDrawerPageDos({
    required this.folders,
    required this.lista,
    required this.pageCtlr,
    super.key,
  });

  final List<Folder> folders;
  final Lista lista;
  final PageController pageCtlr;

  @override
  State<CrudDrawerPageDos> createState() => _CrudDrawerPageDosState();
}

class _CrudDrawerPageDosState extends State<CrudDrawerPageDos> {
  bool isLoading = true;
  late CrudUseCases useCases;
  final _duration300 = const Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    useCases = CrudUseCasesImpl();
    Future.delayed(AppConstants.initialLoadingDuration).then((value) => setState(() {
          isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    // LOADER //
    if (isLoading) {
      return const InitialLoading();
    }

    return Column(
      children: [
        // HEAD
        const DrawerHead(
          text: 'Change folder',
        ),

        // SI NO HAY CATEGORIAS
        if (widget.folders.isEmpty)
          const EmptyScreenBg(
            svgPath: 'assets/svg/empty-folder.svg',
            text: 'There are no folders yet :(\nAdd some from folders section',
          ),

        // LISTA DE CATEGORIAS //
        FadeIn(
            child: ValueListenableBuilder(
          valueListenable: Hive.box<Folder>(AppConstants.foldersDb).listenable(),
          builder: (context, value, child) {
            return ListView.separated(
              shrinkWrap: true,
              itemCount: widget.folders.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Colors.grey.shade400,
                  height: 0,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                var isTheLastTile = index == (widget.folders.length - 1);
                var targetCategId = widget.folders[index].id;
                var isCurrent = widget.folders[index].id == widget.lista.folderId;

                // Categoria actual de la lista

                return DrawerTile(
                  texto: widget.folders[index].name,
                  border: isTheLastTile
                      ? null
                      : const Border(
                          bottom: BorderSide(color: Colors.cyan),
                        ),
                  onTap: () {
                    useCases.changeFolder(
                      targetFolderId: targetCategId,
                      listId: widget.lista.id,
                    );
                    Future.delayed(AppConstants.initialLoadingDuration).then((value) => context.pop());
                  },
                  leading: AnimatedSwitcher(
                    duration: _duration300,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: isCurrent
                        ? Icon(
                            key: ValueKey(widget.lista.folderId),
                            Icons.check_box_rounded,
                            color: Colors.cyan,
                          )
                        : Icon(
                            key: ValueKey(widget.lista.folderId),
                            Icons.check_box_outline_blank_rounded,
                          ),
                  ),
                );
              },
            );
          },
        )),
      ],
    );
  }
}
