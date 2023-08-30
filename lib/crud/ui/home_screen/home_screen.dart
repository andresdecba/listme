import 'package:flutter/material.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/crud/data/crud_use_cases.dart';
import 'package:listme/crud/ui/home_screen/widgets/tab_folders.dart';
import 'package:listme/crud/ui/home_screen/widgets/tab_lists.dart';
//import 'package:listme/crud/ui/home_screen/widgets/drawer_home.dart';

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
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
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
      // KEY //
      key: AppConstants.homeScaffoldKey,

      // DRAWER //
      //drawer: const DrawerHome(),

      // APPBAR //
      appBar: AppBar(
        //title: const Text('ListMe'),
        title: Image.asset(
          'assets/logo-blanco.png',
          height: 20,
        ),
        titleTextStyle: style.titleLarge!.copyWith(color: Colors.white),
        centerTitle: true,
        elevation: 0,
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
              text: 'All my lists',
            ),
            Tab(
              text: 'Folders',
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
          if (_tabController.index == 1) createNewFolder();
        },
      ),

      // BODY //
      body: TabBarView(
        controller: _tabController,
        children: const [
          // lists TAB  //
          TabLists(),
          // ctegories TAB //
          TabFolders(),
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

  void createNewFolder() {
    _crudUseCases.createNewFolder(context: context);
  }
}
