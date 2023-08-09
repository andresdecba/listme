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

                return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: listas.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var key = listas.keys.toList()[index];
                    var currentList = listas.get(key)!;

                    return GestureDetector(
                      onTap: () => context.pushNamed(AppRoutes.crudScreen, extra: key),
                      child: Text(currentList.title),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
