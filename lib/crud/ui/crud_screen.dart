import 'dart:ui';
import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/constants/constants.dart';
import 'package:listme/crud/models/item.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/widgets/create_task_bottomsheet.dart';
import 'package:listme/crud/ui/widgets/input_item.dart';
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

  @override
  void initState() {
    super.initState();
    _box = Hive.box<Lista>(AppConstants.listsCollection);
    _dbList = _box.get(widget.id)!;
    _uuid = const Uuid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appbar
        appBar: AppBar(
          title: Text(_dbList.title),
          backgroundColor: Colors.deepPurple,
        ),

        // button
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            createTaskBottomSheet(
              context: context,
              child: InputItem(
                returnText: (value) {
                  //guardar en la db
                  var id = _uuid.v4();
                  _dbList.items.add(Item(content: value, isDone: false, id: id));
                  _dbList.save();
                },
              ),
              enableDrag: true,
            );
          },
          child: const Icon(Icons.add),
        ),

        // body
        body: ValueListenableBuilder(
          valueListenable: _box.listenable(),
          builder: (context, Box<Lista> box, _) {
            //var lista = box.get(widget.id)!;

            if (_dbList.items.isEmpty) {
              return const Center(
                child: Text("No contacts"),
              );
            }

            return ImplicitlyAnimatedReorderableList<Item>(
              items: _dbList.items,
              shrinkWrap: true,
              areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
              physics: const BouncingScrollPhysics(),

              // reordeable
              onReorderFinished: (item, from, to, newItems) {
                // acá hacer cambios al reordenar
                // item: es el item que fué re-ordenado
                // from: desde el index 'x'
                // to: al index 'y'
                // newItems: es toda la lista ya ordenada
                _dbList.items
                  ..clear()
                  ..addAll(newItems);
                _dbList.save();
              },

              // builder
              itemBuilder: (context, itemAnimation, item, index) {
                // Each item must be wrapped in a Reorderable widget.
                return Reorderable(
                  // Each item must have an unique key.
                  key: ValueKey(item.id),
                  // The animation of the Reorderable builder can be used to
                  // change to appearance of the item between dragged and normal
                  // state. For example to add elevation when the item is being dragged.
                  // This is not to be confused with the animation of the itemBuilder.
                  // Implicit animations (like AnimatedContainer) are sadly not yet supported.
                  builder: (context, dragAnimation, inDrag) {
                    final t = dragAnimation.value;
                    final elevation = lerpDouble(0, 8, t);
                    final color = Color.lerp(Colors.white, Colors.white.withOpacity(0.8), t);

                    return SizeFadeTransition(
                      sizeFraction: 0.7,
                      curve: Curves.easeInOut,
                      animation: itemAnimation,
                      child: Material(
                        color: color,
                        elevation: elevation!,
                        type: MaterialType.transparency,
                        child: ListTile(
                          tileColor: Colors.blue,
                          title: Text(item.content),
                          // The child of a Handle can initialize a drag/reorder.
                          // This could for example be an Icon or the whole item itself. You can
                          // use the delay parameter to specify the duration for how long a pointer
                          // must press the child, until it can be dragged.
                          trailing: const Handle(
                            delay: Duration(milliseconds: 100),
                            child: Icon(
                              Icons.drag_handle_rounded,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ));
  }
}
