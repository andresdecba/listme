import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/crud_screen/widgets/create_new_item.dart';
import 'package:listme/crud/ui/crud_screen/widgets/crud_list.dart';
import 'package:listme/crud/ui/crud_screen/widgets/build_title.dart';

class NewCrudScreen extends StatefulWidget {
  const NewCrudScreen({
    required this.id,
    super.key,
  });

  final String id;

  @override
  State<NewCrudScreen> createState() => _NewCrudScreenState();
}

class _NewCrudScreenState extends State<NewCrudScreen> with CreateNewItem {
  // properties //
  late Box<Lista> _listasDB;
  late Lista lista;
  late ScrollController _scrollCtlr;
  int idxInsert = 0;
  bool insertItemUnderNewCategory = false;
  double bottomSpaceForScroll = 0.0;

  @override
  void initState() {
    super.initState();
    _listasDB = Hive.box<Lista>(AppConstants.listasDb);
    lista = _listasDB.get(widget.id)!;
    _scrollCtlr = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    // variables //
    var date = Helpers.longDateFormater(lista.creationDate);
    final TextTheme txtStyle = Theme.of(context).textTheme;

    // scaffold //
    return Scaffold(
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
            SliverAppBar(
              floating: true,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.menu_rounded),
                ),
              ],
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
                        BuildTitle(
                          initialValue: lista.title,
                          onEditingComplete: (value) {
                            setState(() {
                              lista.title = value;
                              lista.save();
                            });
                          },
                        ),
                        // subtitle //
                        Text(
                          date,
                          style: txtStyle.bodySmall!.copyWith(color: Colors.grey),
                        ),

                        // espacio
                        // const SizedBox(height: 20),
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
