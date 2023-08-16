import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listme/core/routes/routes.dart';
import 'package:listme/crud/data/local_storage_datasource.dart';
import 'package:listme/crud/ui/home_screen/widgets/tab_1.dart';
import 'package:listme/crud/ui/home_screen/widgets/tab_2.dart';
import 'package:listme/crud/ui/shared_widgets/create_task_bottomsheet.dart';
import 'package:listme/crud/ui/shared_widgets/input_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late GlobalKey<AnimatedListState> _listKey;
  late Duration _duration1;
  late Duration _duration2;
  late TabController _tabController;
  late String _bottomSheetTitle;
  late LocalStorageDatasource _datasource;

  @override
  void initState() {
    super.initState();
    _listKey = GlobalKey<AnimatedListState>();
    _duration1 = const Duration(milliseconds: 400);
    _duration2 = const Duration(milliseconds: 600);
    _tabController = TabController(length: 2, vsync: this);
    _bottomSheetTitle = 'Add a new category';
    _datasource = LocalStorageDatasourceImpl();

    _tabController.addListener(() {
      setState(() {
        if (_tabController.index == 0) {
          _bottomSheetTitle = 'Add a new category';
        }
        if (_tabController.index == 1) {
          _bottomSheetTitle = 'Add a new list';
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme style = Theme.of(context).textTheme;

    return Scaffold(
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          onTap: (value) {},
          tabs: const [
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
            title: _bottomSheetTitle,
            child: CustomTextfield(
              onTap: () => setState(() {}),
              onEditingComplete: (value) => setState(() {
                if (_tabController.index == 0) {
                  createNewCategory(categoryName: value);
                }
                if (_tabController.index == 1) {
                  createNewList(listName: value);
                }
              }),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      // BODY //
      body: TabBarView(
        controller: _tabController,
        children: const [
          // TAB 1 //
          TabUno(),

          // TAB 2 //
          TabDos(),
        ],
      ),
    );
  }

  void createNewList({required String listName}) async {
    // nueva lista
    var result = _datasource.createNewList(listName: listName);

    // agregar a la lista animada
    if (_listKey.currentState != null) {
      _listKey.currentState!.insertItem(0, duration: _duration1);
    }
    // esperar para que se vea la animacion en la lista y navegar
    await Future.delayed(_duration2).then((value) {
      context.pushNamed(AppRoutes.crudScreen, extra: result);
    });
  }

  void createNewCategory({required String categoryName}) {
    _datasource.createNewCategory(categoryName: categoryName);
  }
}
