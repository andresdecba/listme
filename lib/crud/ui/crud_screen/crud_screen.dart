import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/crud/models/folder.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/crud_screen/widgets/create_new_item.dart';
import 'package:listme/crud/ui/crud_screen/widgets/drawer_crud.dart';
import 'package:listme/crud/ui/crud_screen/widgets/crud_list.dart';
import 'package:listme/crud/ui/crud_screen/widgets/list_title.dart';
import 'package:animate_do/animate_do.dart';
import 'package:listme/crud/ui/shared_widgets/empty_screen_bg.dart';

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
  late Box<Folder> _foldersDB;
  late Lista lista;
  late ScrollController _scrollCtlr;
  int idxInsert = 0;
  bool insertItemUnderNewCategory = false;
  double bottomSpaceForScroll = 0.0;

  @override
  void initState() {
    super.initState();
    _listasDB = Hive.box<Lista>(AppConstants.listasDb);
    _foldersDB = Hive.box<Folder>(AppConstants.foldersDb);
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
      endDrawer: DrawerCrud(lista: lista),
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
        // stack para que quede fuera del scroll el "empty screen" al final
        child: ValueListenableBuilder(
          valueListenable: _listasDB.listenable(),
          builder: (context, value, child) {
            Folder? coso;
            if (lista.folderId != null) {
              coso = _foldersDB.get(lista.folderId);
            }

            // return CrudList(
            //   scrollCtlr: _scrollCtlr,
            //   lista: lista,
            // );

            return Stack(
              children: [
                CustomScrollView(
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
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 80),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // title //
                                FadeIn(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                                    child: ListTitle(
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

                                // subtitle //
                                FadeIn(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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

                                // crear la lista de items  //
                                CrudList(
                                  scrollCtlr: _scrollCtlr,
                                  lista: lista,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // EMPTY LIST //
                if (lista.items.isEmpty)
                  const EmptyScreenBg(
                    svgPath: 'assets/svg/empty-list.svg',
                    text: 'Here you can add, delete or mark items as done, drag and drop them to order and add separators to organize them.',
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
