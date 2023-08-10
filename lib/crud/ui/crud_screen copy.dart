// import 'dart:ui';
// import 'package:animate_do/animate_do.dart';
// import 'package:animated_list_plus/animated_list_plus.dart';
// import 'package:animated_list_plus/transitions.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:listme/core/constants/constants.dart';
// import 'package:listme/crud/models/item.dart';
// import 'package:listme/crud/models/lista.dart';
// import 'package:listme/crud/ui/widgets/create_task_bottomsheet.dart';
// import 'package:listme/crud/ui/widgets/input_item.dart';
// import 'package:listme/crud/ui/widgets/list_title.dart';
// import 'package:uuid/uuid.dart';

// class CrudScreen extends StatefulWidget {
//   const CrudScreen({
//     required this.id,
//     super.key,
//   });
//   final String id;
//   @override
//   State<CrudScreen> createState() => _CrudScreenState();
// }

// class _CrudScreenState extends State<CrudScreen> {
//   late Box<Lista> _box;
//   late Lista _dbList;
//   late Uuid _uuid;

//   @override
//   void initState() {
//     super.initState();
//     _box = Hive.box<Lista>(AppConstants.listsCollection);
//     _dbList = _box.get(widget.id)!;
//     _uuid = const Uuid();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         // appbar
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//         ),

//         // button
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             createTaskBottomSheet(
//               context: context,
//               showClose: true,
//               child: InputItem(
//                 returnText: (value) {
//                   //guardar en la db
//                   var id = _uuid.v4();
//                   _dbList.items.add(Item(content: value, isDone: false, id: id));
//                   _dbList.save();
//                 },
//               ),
//               enableDrag: true,
//             );
//           },
//           child: const Icon(Icons.add),
//         ),

//         // body
//         body: ValueListenableBuilder(
//           valueListenable: _box.listenable(),
//           builder: (context, Box<Lista> box, _) {
//             if (_dbList.items.isEmpty) {
//               return const Center(
//                 child: Text("No contacts"),
//               );
//             }

//             return Column(
//               children: [
//                 ListTitle(
//                   initialValue: _dbList.title,
//                   returnText: (value) {
//                     _dbList.title = value;
//                     _dbList.save();
//                   },
//                 ),
//                 ImplicitlyAnimatedReorderableList<Item>(
//                   items: _dbList.items,

//                   shrinkWrap: true,
//                   areItemsTheSame: (oldItem, newItem) {
//                     print('jajaja ${oldItem.id == newItem.id}');
//                     return oldItem.id == newItem.id;
//                   },
//                   physics: const BouncingScrollPhysics(),

//                   // reordeable
//                   onReorderFinished: (item, from, to, newItems) {
//                     // acá hacer cambios al reordenar
//                     // item: es el item que fué re-ordenado
//                     // from: desde el index 'x'
//                     // to: al index 'y'
//                     // newItems: es toda nueva la lista ya ordenada
//                     print('jajaja ${newItems}');
//                     _dbList.items
//                       ..clear()
//                       ..addAll(newItems);
//                     _dbList.save();
//                   },

//                   // builder
//                   itemBuilder: (context, itemAnimation, item, index) {
//                     // Each item must be wrapped in a Reorderable widget.
//                     return Reorderable(
//                       // Each item must have an unique key.
//                       key: ValueKey(item.id),
//                       // The animation of the Reorderable builder can be used to
//                       // change to appearance of the item between dragged and normal
//                       // state. For example to add elevation when the item is being dragged.
//                       // This is not to be confused with the animation of the itemBuilder.
//                       // Implicit animations (like AnimatedContainer) are sadly not yet supported.
//                       builder: (context, dragAnimation, inDrag) {
//                         final t = dragAnimation.value;
//                         final elevation = lerpDouble(0, 8, t);
//                         final color = Color.lerp(Colors.white, Colors.white.withOpacity(0.8), t);

//                         return SizeFadeTransition(
//                           sizeFraction: 0.7,
//                           curve: Curves.easeInOut,
//                           animation: itemAnimation,
//                           child: Material(
//                             color: color,
//                             elevation: elevation!,
//                             type: MaterialType.transparency,
//                             child: Handle(
//                               vibrate: true,
//                               delay: const Duration(milliseconds: 150),
//                               child: _ItemTile(
//                                 text: item.content,
//                                 isDone: item.isDone,
//                                 onTapIsDone: () {
//                                   item.isDone = !item.isDone;
//                                   _dbList.save();
//                                 },
//                                 onTapClose: () {
//                                   _dbList.items.remove(item);
//                                   _dbList.save();
//                                 },
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ],
//             );
//           },
//         ));
//   }
// }

// class _ItemTile extends StatelessWidget {
//   const _ItemTile({
//     required this.onTapIsDone,
//     required this.onTapClose,
//     required this.text,
//     required this.isDone,
//   });

//   final VoidCallback onTapClose;
//   final VoidCallback onTapIsDone;
//   final String text;
//   final bool isDone;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.all(4),
//       padding: const EdgeInsets.symmetric(horizontal: 5),
//       decoration: BoxDecoration(
//         color: Colors.cyan.shade300,
//         borderRadius: const BorderRadius.all(Radius.circular(20)),
//       ),
//       child: Row(
//         children: [
//           IconButton(
//             onPressed: () => onTapIsDone(),
//             icon: isDone ? const Icon(Icons.check_circle_rounded) : const Icon(Icons.circle_outlined),
//             padding: EdgeInsets.zero,
//             visualDensity: VisualDensity.compact,
//             iconSize: 20,
//           ),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(
//                 //color: isDone ? Colors.grey.shade500 : Colors.grey,
//                 decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
//                 decorationColor: isDone ? Colors.grey.shade500 : Colors.grey,
//               ),
//             ),
//           ),
//           Visibility(
//             visible: isDone,
//             child: IconButton(
//               onPressed: () => onTapClose(),
//               padding: EdgeInsets.zero,
//               visualDensity: VisualDensity.compact,
//               iconSize: 20,
//               icon: const Icon(Icons.close_rounded),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
