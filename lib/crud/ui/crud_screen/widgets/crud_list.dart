import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/crud/models/item.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/crud_screen/widgets/create_new_item.dart';
import 'package:listme/crud/ui/crud_screen/widgets/sublist_tile.dart';
import 'package:listme/crud/ui/crud_screen/widgets/item_tile.dart';
import 'package:listme/crud/ui/shared_widgets/initial_loading.dart';

class CrudList extends StatefulWidget {
  const CrudList({
    required this.lista,
    required this.scrollCtlr,
    super.key,
  });

  final Lista lista;
  final ScrollController scrollCtlr;

  @override
  State<CrudList> createState() => _CrudListState();
}

class _CrudListState extends State<CrudList> with CreateNewItem {
  int idxInsert = 0;
  double bottomSpaceForScroll = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(AppConstants.initialLoadingDuration).then((value) => setState(() {
          isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    // variables //
    final Size screenSize = MediaQuery.of(context).size;

    // LOADER //
    if (isLoading) {
      return const InitialLoading();
    }

    return widget.lista.items.isEmpty
        // EMPTY LIST //
        ? FadeIn(
            child: SizedBox(
              height: screenSize.height * 0.75,
              child: SvgPicture.asset(
                'assets/add-plus-circle.svg',
                alignment: Alignment.center,
                width: 100,
                color: Colors.grey.shade300,
              ),
            ),
          )

        // LIST //
        : FadeIn(
            child: ImplicitlyAnimatedReorderableList<Item>(
              items: widget.lista.items.toList(),
              reverse: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
              // Updates the underlying data when the list has been reordered.
              onReorderFinished: (item, from, to, newItems) {
                setState(() {
                  widget.lista.items
                    ..clear()
                    ..addAll(newItems.toList());
                  widget.lista.save();
                });
              },
              // Each item must be wrapped in a Reorderable widget and have an unique key.
              itemBuilder: (context, itemAnimation, item, index) {
                // scroll or jump to the category
                // TODO
                // GlobalKey? scrollKey;
                // if (item.isCategory) {
                //   scrollKey = GlobalKey();
                // }

                return Reorderable(
                  key: ValueKey(item.id),
                  builder: (context, dragAnimation, inDrag) {
                    // TODO con estos valores se puede cambiar el widget mientras es arrastrado
                    // buscar mas info del widget "Reorderable"
                    // print('aver dragAnimation: ${dragAnimation.status}');
                    // print('aver inDrag: $inDrag');
                    // if (inDrag) {
                    //   return Text('IN DARG');
                    // }

                    return SizeFadeTransition(
                      sizeFraction: inDrag ? 1 : 0.2,
                      curve: Curves.easeInOut,
                      animation: itemAnimation,
                      child: Handle(
                        delay: const Duration(milliseconds: 300),
                        child: item.isCategory
                            ? SublistTile(
                                // TODO key: scrollKey,
                                text: item.content,
                                onRemove: () => onRemoveItem(item),
                                onAdd: () async {
                                  // TODO
                                  // await Scrollable.ensureVisible(
                                  //   scrollKey!.currentContext!,
                                  //   curve: Curves.easeIn,
                                  //   duration: const Duration(milliseconds: 300),
                                  // );
                                  onCreateNewItem(
                                    context: context,
                                    lista: widget.lista,
                                    indexUnderSublist: index,
                                    scrollCtlr: widget.scrollCtlr,
                                  );
                                },
                              )
                            : ItemTile(
                                // TODO key: scrollKey,
                                text: item.content,
                                isDone: item.isDone,
                                onTapIsDone: () {
                                  onDone(item);
                                  SystemSound.play(SystemSoundType.click);
                                },
                                onRemove: () => onRemoveItem(item),
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          );
  }

  //// LOGICA ////
  void onDone(Item item) {
    setState(() {
      item.isDone = !item.isDone;
      widget.lista.save();
    });
  }

  void onRemoveItem(Item item) {
    setState(() {
      widget.lista.items.remove(item);
      widget.lista.save();
    });
  }
}
