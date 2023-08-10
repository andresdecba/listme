import 'package:flutter/material.dart';
import 'package:great_list_view/great_list_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/constants/constants.dart';
import 'package:listme/core/constants/typedefs.dart';
import 'package:listme/crud/models/item.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/widgets/create_task_bottomsheet.dart';
import 'package:listme/crud/ui/widgets/input_item.dart';
import 'package:listme/crud/ui/widgets/item_tile.dart';
import 'package:listme/crud/ui/widgets/list_title.dart';
import 'package:uuid/uuid.dart';

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
  late Uuid _uuid;
  late GlobalKey<AnimatedListState> _globalKey;

  final scrollController = ScrollController();
  final controller = AnimatedListController();

  @override
  void initState() {
    super.initState();
    _box = Hive.box<Lista>(AppConstants.listsCollection);
    _dbList = _box.get(widget.id)!;
    _uuid = const Uuid();
    _globalKey = GlobalKey<AnimatedListState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // APPBAR //
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),

        // ADD BUTTON //
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            createTaskBottomSheet(
              context: context,
              showClose: true,
              child: InputItem(
                returnText: (value) {
                  //guardar en la db
                  var id = _uuid.v4();
                  _dbList.items.add(Item(content: value, isDone: false, id: id));
                  _dbList.save();
                  // agregar a la lista animada
                  _globalKey.currentState!.insertItem(0, duration: const Duration(milliseconds: 400));
                },
              ),
              enableDrag: true,
            );
          },
          child: const Icon(Icons.add),
        ),

        // BODY //
        body: Visibility(
          visible: _dbList.items.isNotEmpty,
          replacement: const Center(child: Text("No items")),
          child: Column(
            children: [
              // TITLE //
              ListTitle(
                initialValue: _dbList.title,
                returnText: (value) {
                  setState(() {
                    _dbList.title = value;
                    _dbList.save();
                  });
                },
              ),

              // ITEMS LIST //
              MyCustomAnimatedList(
                list: _dbList.items,
                globalKey: _globalKey,
                child: (i) {
                  var item = _dbList.items[i];
                  return ItemTile(
                    text: item.content,
                    isDone: item.isDone,
                    onTapIsDone: () => _onDone(item),
                    onTapClose: () => _onClose(item, i),
                  );
                },
              ),
            ],
          ),
        )

        // ValueListenableBuilder(
        //   valueListenable: _box.listenable(),
        //   builder: (context, Box<Lista> box, _) {},
        // ),
        );
  }

  void _onDone(Item item) {
    setState(() {
      item.isDone = !item.isDone;
      _dbList.save();
    });
  }

  void _onClose(Item item, int i) {
    setState(() {
      _globalKey.currentState!.removeItem(i, (context, animation) {
        return FadeTransition(
          key: UniqueKey(),
          opacity: animation,
          child: SizeTransition(
            key: UniqueKey(),
            sizeFactor: animation,
            child: ItemTile(
              onTapIsDone: () {},
              onTapClose: () {},
              text: item.content,
              isDone: item.isDone,
            ),
          ),
        );
      });
      _dbList.items.remove(item);
      _dbList.save();
    });
  }
}

class MyCustomAnimatedList extends StatefulWidget {
  const MyCustomAnimatedList({
    required this.list,
    required this.child,
    required this.globalKey,
    super.key,
  });

  final List<dynamic> list;
  final ReturnWidget child;
  final GlobalKey<AnimatedListState> globalKey;

  @override
  State<MyCustomAnimatedList> createState() => _MyCustomAnimatedListState();
}

class _MyCustomAnimatedListState extends State<MyCustomAnimatedList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: widget.globalKey,
      reverse: true,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      initialItemCount: widget.list.length,
      itemBuilder: (context, index, animation) {
        return FadeTransition(
          key: UniqueKey(),
          opacity: animation,
          child: SizeTransition(
            key: UniqueKey(),
            sizeFactor: animation,
            child: widget.child(index),
          ),
        );
      },
    );
  }
}
