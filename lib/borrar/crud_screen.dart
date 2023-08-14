import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/crud/models/item.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/shared_widgets/create_task_bottomsheet.dart';
import 'package:listme/crud/ui/shared_widgets/input_item.dart';
import 'package:listme/crud/ui/crud_screen/widgets/item_category_tile.dart';
import 'package:listme/crud/ui/crud_screen/widgets/item_tile.dart';
import 'package:listme/crud/ui/crud_screen/widgets/list_title.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({
    required this.id,
    super.key,
  });
  final String id;
  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  late Box<Lista> _box;
  late Lista _dbList;
  late ScrollController _scrollCtlr;
  int idxInsert = 0;
  bool toNewCategory = false;
  double bottomSpaceForScroll = 0.0;

  @override
  void initState() {
    super.initState();
    _box = Hive.box<Lista>(AppConstants.listsCollection);
    _dbList = _box.get(widget.id)!;
    _scrollCtlr = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    var date = Helpers.longDateFormater(_dbList.creationDate);
    final TextTheme txtStyle = Theme.of(context).textTheme;
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      extendBody: true,

      // APP BAR //
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu_rounded),
          ),
        ],
      ),

      // BUTTON //
      floatingActionButton: FloatingActionButton(
        onPressed: () => onCreateFloatingActionBtn(),
        child: const Icon(Icons.add),
      ),

      // BODY //
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(15, 0, 15, MediaQuery.of(context).viewInsets.bottom),
        controller: _scrollCtlr,
        child: Column(
          children: [
            // TÍTULO + date //
            ListTitle(
              initialValue: _dbList.title,
              onEditingComplete: (value) {
                setState(() {
                  _dbList.title = value;
                  _dbList.save();
                });
              },
            ),
            Text(
              date,
              style: txtStyle.bodySmall!.copyWith(color: Colors.grey),
            ),

            // SI NO HAY TAREAS //
            if (_dbList.items.isEmpty)
              SizedBox(
                height: screenSize.height * 0.75,
                child: SvgPicture.asset(
                  'assets/add-plus-circle.svg',
                  alignment: Alignment.center,
                  width: 100,
                  color: Colors.grey.shade300,
                ),
              ),

            // COMIENZO LISTA //
            ImplicitlyAnimatedReorderableList<Item>(
              items: _dbList.items.reversed.toList(),
              reverse: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
              // Updates the underlying data when the list has been reordered.
              onReorderFinished: (item, from, to, newItems) {
                setState(() {
                  _dbList.items
                    ..clear()
                    ..addAll(newItems.reversed.toList());
                  _dbList.save();
                });
              },
              // Each item must be wrapped in a Reorderable widget and have an unique key.
              itemBuilder: (context, itemAnimation, item, index) {
                //TODO
                // scroll or jump to the category
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
                                //key: scrollKey,
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
                                  //key: scrollKey,
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
            ),
            const SizedBox(height: 75),
            //SizedBox(height: bottomSpaceForScroll),
          ],
        ),
      ),
    );
  }

  void onDone(Item item) {
    setState(() {
      item.isDone = !item.isDone;
      _dbList.save();
    });
  }

  void onRemoveItem(Item item) {
    setState(() {
      _dbList.items.remove(item);
      _dbList.save();
    });
  }

  void onCreateCategoryBtn(double screenHeight, int index) {
    setState(() {
      print('jajajaj $screenHeight');
      bottomSpaceForScroll = screenHeight;
    });
    createTaskBottomSheet(
      context: context,
      showClose: true,
      enableDrag: true,
      onClose: () {
        toNewCategory = false;
        bottomSpaceForScroll = 0.0;
      },
      child: InputItem(
        onTap: () {},
        dbList: _dbList,
        returnItem: (value) {
          setState(() {
            //debido a que la lista está invertida hay que calcular donde caerá el insert
            toNewCategory ? idxInsert = _dbList.items.length - 1 : idxInsert = _dbList.items.length - (index + 1);
            if (value.isCategory) {
              scrollTo(0);
              toNewCategory = true;
              _dbList.items.add(value);
              _dbList.save();
            } else {
              _dbList.items.insert(idxInsert, value);
              _dbList.save();
            }
          });
        },
      ),
    );
  }

  void onCreateFloatingActionBtn() {
    createTaskBottomSheet(
      context: context,
      showClose: true,
      enableDrag: true,
      onClose: () => toNewCategory = false,
      child: InputItem(
        onTap: () {},
        dbList: _dbList,
        returnItem: (value) {
          setState(() {
            scrollTo(0);
            toNewCategory ? idxInsert = _dbList.items.length - 1 : idxInsert = _dbList.items.length;
            if (value.isCategory) {
              toNewCategory = true;
              _dbList.items.add(value);
              _dbList.save();
            } else {
              _dbList.items.insert(idxInsert, value);
              _dbList.save();
            }
          });
        },
      ),
    );
  }

  void scrollTo(double offset) {
    _scrollCtlr.animateTo(
      offset,
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
    );
  }
}

/*
ValueListenableBuilder(
  valueListenable: _box.listenable(),
  builder: (context, Box<Lista> box, _) {
    // SI ESTÁ VACÍA //
    if (_dbList.items.isEmpty) {
      return const Center(
        child: Text("NO ITEMS"),
      );
    }
    return ;
  },
),
*/
