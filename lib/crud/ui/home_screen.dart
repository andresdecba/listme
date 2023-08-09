import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listme/core/routes/routes.dart';
import 'package:listme/crud/data/local_storage_datasource.dart';
import 'package:listme/crud/models/item_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late LocalStorageDatasource db;

  List<ItemList> initialData = [];

  @override
  void initState() {
    super.initState();
    db = LocalStorageDatasourceImpl();
  }

  @override
  Widget build(BuildContext context) {
    final myItem = Item(
      content: "holaaaa",
      isDone: true,
    );

    final myList = ItemList(
      title: 'list title',
      creationDate: DateTime.now(),
      items: [myItem, myItem],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('ListMe'),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => db.setItemList(myList),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const Text(
            'Listas creadas',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          FutureBuilder(
            future: db.getAllItemList(),
            initialData: initialData,
            builder: (BuildContext context, AsyncSnapshot<List<ItemList>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.data!.isEmpty) {
                return const Center(child: Text('no hay nada'));
              }

              return ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => context.pushNamed(AppRoutes.crudScreen, extra: snapshot.data![index].id),
                    child: Center(
                      child: Text(snapshot.data![index].title),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
