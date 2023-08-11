import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/crud/models/item.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/widgets/create_task_bottomsheet.dart';
import 'package:listme/crud/ui/widgets/input_item.dart';
import 'package:listme/crud/ui/widgets/item_category_tile.dart';
import 'package:listme/crud/ui/widgets/item_tile.dart';
import 'package:listme/crud/ui/widgets/list_title.dart';

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

  final List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    _box = Hive.box<Lista>(AppConstants.listsCollection);
    _dbList = _box.get(widget.id)!;
  }

  @override
  Widget build(BuildContext context) {
    var date = Helpers.longDateFormater(_dbList.creationDate);
    final TextTheme txtStyle = Theme.of(context).textTheme;
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
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
        onPressed: () => onCreateNewItem(),
        child: const Icon(Icons.add),
      ),

      // BODY //
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: Expanded(
          child: Column(
            children: [
              // TÍTULO //
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
              const SizedBox(height: 20),

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

                      // scroll or jump to the category

                      // GlobalKey? itemKey;
                      // if (item.isCategory) {
                      //   itemKey = GlobalKey();
                      //   categories.add({'name': item.content, 'gKey': itemKey});
                      // }

                      return SizeFadeTransition(
                        sizeFraction: inDrag ? 1 : 0.2,
                        curve: Curves.easeInOut,
                        animation: itemAnimation,
                        child: Handle(
                          delay: const Duration(milliseconds: 250),
                          child: item.isCategory
                              ? ItemCategoryTile(
                                  key: item.key,
                                  text: item.content,
                                  onTap: () async {
                                    await Scrollable.ensureVisible(
                                      item.key!.currentContext!,
                                      curve: Curves.easeIn,
                                      duration: const Duration(milliseconds: 300),
                                    );
                                    onInserNewItem(index);
                                  },
                                )
                              : ItemTile(
                                  onTapIsDone: () => onDone(item),
                                  onTapClose: () => onClose(item),
                                  text: item.content,
                                  isDone: item.isDone,
                                ),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(
                height: screenSize.height,
              )
            ],
          ),
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

  void onClose(Item item) {
    setState(() {
      _dbList.items.remove(item);
      _dbList.save();
    });
  }

  void onInserNewItem(int index) {
    createTaskBottomSheet(
      context: context,
      showClose: true,
      child: InputItem(
        dbList: _dbList,
        returnItem: (value) {
          setState(() {
            //debido a que la lista está invertida hay que calcular donde caerá el insert
            var idxInsert = _dbList.items.length - (index + 1);
            //guardar en la db
            _dbList.items.insert(idxInsert, value);
            _dbList.save();
          });
        },
      ),
      enableDrag: true,
    );
  }

  void onCreateNewItem() {
    print('cososos ${categories.length}');
    createTaskBottomSheet(
      context: context,
      showClose: true,
      child: InputItem(
        dbList: _dbList,
        returnItem: (value) {
          setState(() {
            //guardar en la db
            _dbList.items.add(value);
            _dbList.save();
          });
        },
      ),
      enableDrag: true,
    );
  }
}

/*
      body: ValueListenableBuilder(
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
