import 'package:flutter/material.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/crud/data/crud_use_cases.dart';
import 'package:listme/crud/ui/home_screen/widgets/tab_categories.dart';
import 'package:listme/crud/ui/home_screen/widgets/tab_all_lists.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late GlobalKey<AnimatedListState> _listKey;
  late TabController _tabController;
  late CrudUseCases _crudUseCases;

  @override
  void initState() {
    super.initState();
    _listKey = GlobalKey<AnimatedListState>();
    _tabController = TabController(length: 2, vsync: this);
    _crudUseCases = CrudUseCasesImpl();
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
      key: AppConstants.homeScaffoldKey,
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
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white,
          labelStyle: style.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
          unselectedLabelStyle: style.bodyMedium,
          onTap: (value) {},
          tabs: const [
            Tab(
              text: 'My lists',
            ),
            Tab(
              text: 'My categories',
            ),
          ],
        ),
      ),

      // ADD A LIST //
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          if (_tabController.index == 0) createNewList();
          if (_tabController.index == 1) createNewCategory();
        },
      ),

      // BODY //
      body: TabBarView(
        controller: _tabController,
        children: const [
          // lists TAB  //
          AllListsTab(),
          // ctegories TAB //
          CategoriesTab(),
        ],
      ),
    );
  }

  void createNewList() async {
    // nueva lista
    _crudUseCases.createNewList(context: context);
    // agregar a la lista animada
    if (_listKey.currentState != null) {
      _listKey.currentState!.insertItem(0, duration: const Duration(milliseconds: 400));
    }
  }

  void createNewCategory() {
    _crudUseCases.createNewCategory(context: context);
  }
}
