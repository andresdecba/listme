import 'package:flutter/material.dart';
import 'package:listme/crud/data/local_storage_datasource.dart';
import 'package:listme/crud/models/item_list.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({
    required this.docId,
    super.key,
  });
  final int docId;
  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  late LocalStorageDatasource db;

  @override
  void initState() {
    super.initState();
    db = LocalStorageDatasourceImpl();
  }

  // late String _title;
  // late DateTime _creationDate;
  // List<Item> _items = [];

  final ItemList _listaylor = ItemList(
    title: 'cosoo nuevo',
    creationDate: DateTime.now(),
    items: [],
  );

  Item newItem = Item(content: 'newwww item', isDone: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar
      appBar: AppBar(
        title: Text('Lista ${widget.docId}'),
        backgroundColor: Colors.deepPurple,
      ),
      // button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _listaylor.items.add(newItem);

          db.setItemList(_listaylor);
        },
        child: const Icon(Icons.add),
      ),

      // body
      body: Column(
        children: [
          FutureBuilder(
            future: db.getItemList(widget.docId),
            //initialData: InitialData,
            builder: (BuildContext context, AsyncSnapshot<ItemList> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                // _title = snapshot.data!.title;
                // _creationDate = snapshot.data!.creationDate;
                // _items = snapshot.data!.items ?? [];

                // _listaylor = snapshot.data!.copiWith(
                //   title: snapshot.data!.title,
                //   creationDate: snapshot.data!.creationDate,
                //   items: snapshot.data!.items,
                // );
              }
              //return Text('peneee');
              return ListView(
                shrinkWrap: true,
                children: [
                  ...snapshot.data!.items.map((e) => Text(e.content)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
