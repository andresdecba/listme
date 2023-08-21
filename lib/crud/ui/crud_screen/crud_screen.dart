import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/crud/models/list_category.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/crud_screen/widgets/create_new_item.dart';
import 'package:listme/crud/ui/crud_screen/widgets/drawer.dart';
import 'package:listme/crud/ui/crud_screen/widgets/crud_list.dart';
import 'package:listme/crud/ui/crud_screen/widgets/build_title.dart';
import 'package:animate_do/animate_do.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({
    required this.id,
    super.key,
  });

  final String id;

  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> with CreateNewItem {
  // properties //
  late Box<Lista> _listasDB;
  late Box<Category> _categoriesDB;
  late Lista lista;
  late ScrollController _scrollCtlr;
  int idxInsert = 0;
  bool insertItemUnderNewCategory = false;
  double bottomSpaceForScroll = 0.0;

  @override
  void initState() {
    super.initState();
    _listasDB = Hive.box<Lista>(AppConstants.listasDb);
    _categoriesDB = Hive.box<Category>(AppConstants.categoriesDb);
    lista = _listasDB.get(widget.id)!;
    _scrollCtlr = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    // variables //
    var date = Helpers.longDateFormater(lista.creationDate);
    final TextTheme txtStyle = Theme.of(context).textTheme;

    return Scaffold(
      // key
      key: AppConstants.crudScaffoldKey,

      // DRAWER
      endDrawer: CrudDrawer(lista: lista),
      endDrawerEnableOpenDragGesture: false,

      // ADD LISTA BTN //
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () {
          onCreateNewItem(
            context: context,
            lista: lista,
            scrollCtlr: _scrollCtlr,
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      // BODY //
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollCtlr,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // APP BAR //
            const SliverAppBar(
              floating: true,
            ),

            // BODY CONTENT//
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        // title //
                        FadeIn(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: BuildTitle(
                              initialValue: lista.title,
                              onEditingComplete: (value) {
                                setState(() {
                                  lista.title = value;
                                  lista.save();
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),

                        // subtitle //
                        ValueListenableBuilder(
                          valueListenable: _listasDB.listenable(),
                          builder: (context, value, child) {
                            Category? coso;
                            if (lista.categoryId != null) {
                              coso = _categoriesDB.get(lista.categoryId);
                            }
                            return FadeIn(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Expanded(
                                  child: RichText(
                                    text: coso != null
                                        ? TextSpan(
                                            text: '$date  -  ',
                                            style: txtStyle.bodyMedium!.copyWith(color: Colors.grey),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: coso.name,
                                                style: txtStyle.bodyMedium!.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
                                              )
                                            ],
                                          )
                                        : TextSpan(
                                            text: date,
                                            style: txtStyle.bodyMedium!.copyWith(color: Colors.grey),
                                          ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // crear la lista de items  //
                        ValueListenableBuilder(
                          valueListenable: _listasDB.listenable(),
                          builder: (context, db, child) {
                            return Column(
                              children: [
                                if (lista.items.isNotEmpty && !lista.items.first.isCategory) const SizedBox(height: 30),
                                CrudList(
                                  scrollCtlr: _scrollCtlr,
                                  lista: lista,
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
