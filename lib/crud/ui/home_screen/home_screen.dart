import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/routes/routes.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/home_screen/widgets/list_tile.dart';
import 'package:listme/crud/ui/home_screen/widgets/lists_separator.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Lista> _box = Hive.box(AppConstants.listsCollection);
  late Uuid _uuid;
  late GlobalKey<AnimatedListState> _listKey;
  final Duration _duration1 = const Duration(milliseconds: 400);
  final Duration _duration2 = const Duration(milliseconds: 600);

  @override
  void initState() {
    super.initState();
    _box = Hive.box<Lista>(AppConstants.listsCollection);
    _uuid = const Uuid();
    _listKey = GlobalKey<AnimatedListState>();
  }

  void createNewList() async {
    final emptyList = Lista(
      title: "lista vacía",
      creationDate: DateTime.now(),
      items: [],
      id: _uuid.v4(),
    );
    // agregar a la db
    _box.put(emptyList.id, emptyList);
    // agregar a la lista animada
    if (_listKey.currentState != null) {
      _listKey.currentState!.insertItem(0, duration: _duration1);
    }
    // esperar para que se vea la animacion y navegar
    await Future.delayed(_duration2).then((value) {
      context.pushNamed(AppRoutes.crudScreen, extra: emptyList.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APPBAR //
      appBar: AppBar(
        title: const Text('ListMe'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu_rounded,
          ),
        ),
        backgroundColor: Colors.cyan,
      ),

      // ADD A LIST //
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewList(),
        child: const Icon(Icons.add),
      ),

      // BODY //
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CATEGORIAS //
            const ListSeparator(text: 'Trabajo'),
            const SizedBox(height: 10),

            // MOSTRAR LISTAS //
            ValueListenableBuilder(
              valueListenable: Hive.box<Lista>(AppConstants.listsCollection).listenable(),
              builder: (context, Box<Lista> listas, _) {
                // no lists
                if (listas.values.isEmpty) {
                  return const Center(
                    child: Text("No hay listas"),
                  );
                }

                // lists
                return ImplicitlyAnimatedList<Lista>(
                  shrinkWrap: true,
                  items: listas.values.toList(),
                  areItemsTheSame: (a, b) => a.id == b.id,
                  itemBuilder: (context, animation, item, index) {
                    return SizeFadeTransition(
                      sizeFraction: 0.7,
                      curve: Curves.easeInOut,
                      animation: animation,
                      child: CustomListTile(
                        titleText: item.title,
                        subTitleText: "20-06-2023",
                        onTap: () => context.pushNamed(AppRoutes.crudScreen, extra: item.id),
                        keyId: item.id,
                        onRemove: () {
                          item.delete();
                        },
                      ),
                    );
                  },
                  removeItemBuilder: (context, animation, oldItem) {
                    return FadeTransition(
                      opacity: animation,
                      child: CustomListTile(
                        titleText: oldItem.title,
                        subTitleText: "20-06-2023",
                        onTap: () {},
                        keyId: oldItem.id,
                        onRemove: () {},
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
