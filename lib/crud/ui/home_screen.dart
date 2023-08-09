import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listme/core/routes/routes.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/models/repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Lista> listas = [
    listaUno,
    listaDos,
    listaTres,
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListMe'),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          listas.add(listaCuatro);
        }),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const Text(
            'Listas creadas',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: listas.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              var item = listas[index];
              return GestureDetector(
                onTap: () => context.pushNamed(AppRoutes.crudScreen, extra: item),
                child: Text('${item.title}  //  ${item.id}'),
              );
            },
          ),
        ],
      ),
    );
  }
}
