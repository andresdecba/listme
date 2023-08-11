import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/routes/routes.dart';
import 'package:listme/crud/models/lista.dart';
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
      appBar: AppBar(
        title: const Text('ListMe'),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewList(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Text(
              'Listas creadas',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder(
              valueListenable: Hive.box<Lista>(AppConstants.listsCollection).listenable(),
              builder: (context, Box<Lista> listas, _) {
                if (listas.values.isEmpty) {
                  return const Center(
                    child: Text("No contacts"),
                  );
                }

                return Expanded(
                  child: AnimatedList(
                    key: _listKey,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    initialItemCount: listas.length,
                    itemBuilder: (context, index, animation) {
                      var key = listas.keys.toList()[index];
                      var currentList = listas.get(key)!;

                      var deleteWidget = _ListTile(
                        titleText: currentList.title,
                        subTitleText: "20-06-2023",
                        onTap: () {},
                        keyId: currentList.id,
                        onRemove: () {},
                      );

                      return FadeTransition(
                          key: UniqueKey(),
                          opacity: animation,
                          child: SizeTransition(
                            key: UniqueKey(),
                            sizeFactor: animation,
                            child: _ListTile(
                              titleText: currentList.title,
                              subTitleText: "20-06-2023",
                              onTap: () => context.pushNamed(AppRoutes.crudScreen, extra: key),
                              keyId: currentList.id,
                              onRemove: () {
                                setState(() {
                                  _listKey.currentState!.removeItem(index, (context, animation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: SizeTransition(
                                        sizeFactor: animation,
                                        child: deleteWidget,
                                      ),
                                    );
                                  });
                                  currentList.delete();
                                });
                              },
                            ),
                          ));
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({
    required this.titleText,
    required this.subTitleText,
    required this.onTap,
    required this.keyId,
    required this.onRemove,
  });

  final String titleText;
  final String subTitleText;
  final VoidCallback onTap;
  final String keyId;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final double widthScreen = MediaQuery.of(context).size.width;

    // dissmiss
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        height: 75,
        width: widthScreen,
        margin: const EdgeInsets.all(4),
        //padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 10),
            const _ProgressWidget(),
            const SizedBox(width: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      titleText,
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                      style: style.bodyLarge,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      subTitleText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: style.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => onRemove(),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                iconSize: 20,
                icon: const Icon(Icons.close_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressWidget extends StatelessWidget {
  const _ProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
    );
  }
}
