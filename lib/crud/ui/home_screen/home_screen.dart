import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/routes/routes.dart';
import 'package:listme/crud/models/list_category.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/home_screen/widgets/tab_1.dart';
import 'package:listme/crud/ui/home_screen/widgets/tab_2.dart';
import 'package:listme/crud/ui/shared_widgets/create_task_bottomsheet.dart';
import 'package:listme/crud/ui/shared_widgets/input_item.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<ListCategory> _categoriesDb;
  late Box<Lista> _listasDb;
  late Uuid _uuid;
  late GlobalKey<AnimatedListState> _listKey;
  late Duration _duration1;
  late Duration _duration2;

  @override
  void initState() {
    super.initState();
    _categoriesDb = Hive.box(AppConstants.categoriesDb);
    _listasDb = Hive.box(AppConstants.listasDb);
    _uuid = const Uuid();
    _listKey = GlobalKey<AnimatedListState>();
    _duration1 = const Duration(milliseconds: 400);
    _duration2 = const Duration(milliseconds: 600);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme style = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // APPBAR //
        appBar: AppBar(
          title: const Text('ListMe'),
          titleTextStyle: style.titleLarge!.copyWith(color: Colors.white),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu_rounded,
            ),
          ),
          backgroundColor: Colors.cyan,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabs: [
              Tab(text: 'My lists by categories'),
              Tab(text: 'My lists'),
            ],
          ),
        ),

        // ADD A LIST //
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            customBottomSheet(
              context: context,
              showClose: true,
              enableDrag: true,
              onClose: () {},
              child: CustomTextfield(
                onTap: () => setState(() {}),
                onEditingComplete: (value) => setState(() {
                  createNewCategory(categoryName: value);
                }),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),

        // BODY //
        body: const TabBarView(
          children: [
            // TAB 1 //
            TabUno(),

            // TAB 2 //
            TabDos(),
          ],
        ),
      ),
    );
  }

  void createNewList({required String listName}) async {
    // nueva lista
    final newList = Lista(
      title: listName,
      creationDate: DateTime.now(),
      items: [],
      id: _uuid.v4(),
    );
    // agregar a la db
    _listasDb.put(newList.id, newList);
    // agregar a la lista animada
    if (_listKey.currentState != null) {
      _listKey.currentState!.insertItem(0, duration: _duration1);
    }
    // esperar para que se vea la animacion en la lista y navegar
    await Future.delayed(_duration2).then((value) {
      context.pushNamed(AppRoutes.crudScreen, extra: newList.id);
    });
  }

  void createNewCategory({
    required String categoryName,
  }) {
    final ListCategory newCategory = ListCategory(
      categoryName: categoryName,
      isExpanded: true,
      categoryId: _uuid.v4(),
      listsIds: [],
    );
    _categoriesDb.put(newCategory.categoryId, newCategory);
  }
}
