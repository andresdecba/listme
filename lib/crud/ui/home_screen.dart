import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/constants/constants.dart';
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

  @override
  void initState() {
    super.initState();
    _box = Hive.box<Lista>(AppConstants.listsCollection);
    _uuid = const Uuid();
  }

  void createNewList() {
    final emptyList = Lista(
      title: "lista vacía",
      creationDate: DateTime.now(),
      items: [],
      id: _uuid.v4(),
    );
    _box.put(emptyList.id, emptyList);
    context.pushNamed(AppRoutes.crudScreen, extra: emptyList.id);
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
                  child: ListView.builder(
                    itemCount: listas.length,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      var key = listas.keys.toList()[index];
                      var currentList = listas.get(key)!;

                      List<String> subTitle = [];
                      if (currentList.items.isNotEmpty) {
                        for (var element in currentList.items) {
                          if (element.content.length > 12) {
                            subTitle.add('${element.content.substring(0, 12)}...');
                          } else {
                            subTitle.add(element.content);
                          }
                        }
                      }

                      return _ListTile(
                        titleText: currentList.title,
                        subTitleText: subTitle.isEmpty ? 'lista vacía' : subTitle.toString(),
                        onTap: () => context.pushNamed(AppRoutes.crudScreen, extra: key),
                        keyId: currentList.id,
                        onTapClose: () => currentList.delete(),
                      );
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
    required this.onTapClose,
  });

  final String titleText;
  final String subTitleText;
  final VoidCallback onTap;
  final String keyId;
  final VoidCallback onTapClose;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;

    // dissmiss
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        height: 75,
        width: double.infinity,
        margin: const EdgeInsets.all(4),
        //padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  Text(
                    titleText,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    style: style.bodyLarge,
                  ),
                  Text(
                    subTitleText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: style.bodySmall,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => onTapClose(),
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
