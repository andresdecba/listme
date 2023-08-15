import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:listme/crud/models/item.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/shared_widgets/create_task_bottomsheet.dart';
import 'package:listme/crud/ui/shared_widgets/input_item.dart';
import 'package:listme/crud/ui/crud_screen/widgets/item_category_tile.dart';
import 'package:listme/crud/ui/crud_screen/widgets/item_tile.dart';

class CrudList extends StatefulWidget {
  const CrudList({
    required this.dbList,
    required this.scrollCtlr,
    super.key,
  });

  final Lista dbList;
  final ScrollController scrollCtlr;

  @override
  State<CrudList> createState() => _CrudListState();
}

class _CrudListState extends State<CrudList> {
  int idxInsert = 0;
  bool toNewCategory = false;
  double bottomSpaceForScroll = 0.0;
  bool _showBottomSheet = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // variables //
    final Size screenSize = MediaQuery.of(context).size;

    return widget.dbList.items.isEmpty
        // EMPTY LIST //
        ? SizedBox(
            height: screenSize.height * 0.75,
            child: SvgPicture.asset(
              'assets/add-plus-circle.svg',
              alignment: Alignment.center,
              width: 100,
              color: Colors.grey.shade300,
            ),
          )

        // LIST //
        : ImplicitlyAnimatedReorderableList<Item>(
            items: widget.dbList.items.reversed.toList(),
            reverse: false,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
            // Updates the underlying data when the list has been reordered.
            onReorderFinished: (item, from, to, newItems) {
              setState(() {
                widget.dbList.items
                  ..clear()
                  ..addAll(newItems.reversed.toList());
                widget.dbList.save();
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
                key: ValueKey(item),
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
                      delay: item.isCategory ? const Duration(milliseconds: 500) : const Duration(milliseconds: 250),
                      child: item.isCategory
                          ? ItemCategoryTile(
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
                                onCreateCategoryBtn(screenSize.height, index);
                              },
                            )
                          : Padding(
                              // espacio dinámico entre el título y el primer elemento de la lista
                              padding: index == 0 ? const EdgeInsets.fromLTRB(0, 20, 0, 0) : EdgeInsets.zero,
                              child: ItemTile(
                                // TODO key: scrollKey,
                                onTapIsDone: () => onDone(item),
                                onRemove: () => onRemoveItem(item),
                                text: item.content,
                                isDone: item.isDone,
                              ),
                            ),
                    ),
                  );
                },
              );
            },
          );
  }

  //// LOGICA ////
  void onDone(Item item) {
    setState(() {
      item.isDone = !item.isDone;
      widget.dbList.save();
    });
  }

  void onRemoveItem(Item item) {
    setState(() {
      widget.dbList.items.remove(item);
      widget.dbList.save();
    });
  }

  void onCreateCategoryBtn(double screenHeight, int index) {
    setState(() {
      bottomSpaceForScroll = screenHeight;
    });
    customBottomSheet(
      context: context,
      showClose: true,
      enableDrag: true,
      onClose: () {
        toNewCategory = false;
        bottomSpaceForScroll = 0.0;
      },
      child: CustomTextfield(
        onTap: () {
          setState(() {
            _showBottomSheet = !_showBottomSheet;
          });
        },
        onEditingComplete: (value) {
          // setState(() {
          //   //debido a que la lista está invertida hay que calcular donde caerá el insert
          //   toNewCategory ? idxInsert = widget.dbList.items.length - 1 : idxInsert = widget.dbList.items.length - (index + 1);
          //   if (value.isCategory) {
          //     scrollTo(0);
          //     toNewCategory = true;
          //     widget.dbList.items.add(value);
          //     widget.dbList.save();
          //   } else {
          //     widget.dbList.items.insert(idxInsert, value);
          //     widget.dbList.save();
          //   }
          // });
        },
      ),
    );
  }

  void scrollTo(double offset) {
    widget.scrollCtlr.animateTo(
      offset,
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
    );
  }
}
