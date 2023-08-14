import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/widgets/create_task_bottomsheet.dart';
import 'package:listme/crud/ui/widgets/crud_list.dart';
import 'package:listme/crud/ui/widgets/input_item.dart';
import 'package:listme/crud/ui/widgets/list_title.dart';

class NewCrudScreen extends StatefulWidget {
  const NewCrudScreen({
    required this.id,
    super.key,
  });

  final String id;

  @override
  State<NewCrudScreen> createState() => _NewCrudScreenState();
}

class _NewCrudScreenState extends State<NewCrudScreen> {
  // properties //
  late Box<Lista> _box;
  late Lista _dbList;
  late ScrollController _scrollCtlr;
  int idxInsert = 0;
  bool toNewCategory = false;
  double bottomSpaceForScroll = 0.0;
  bool _showBottomSheet = false;

  @override
  void initState() {
    super.initState();
    _box = Hive.box<Lista>(AppConstants.listsCollection);
    _dbList = _box.get(widget.id)!;
    _scrollCtlr = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    // variables //
    var date = Helpers.longDateFormater(_dbList.creationDate);
    final TextTheme txtStyle = Theme.of(context).textTheme;

    // scaffold //
    return Scaffold(
      // action btn //
      floatingActionButton: !_showBottomSheet
          ? FloatingActionButton(
              backgroundColor: Colors.orangeAccent,
              onPressed: () {
                setState(() {
                  _showBottomSheet = !_showBottomSheet;
                  onCreateFloatingActionBtn();
                });
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,

      // bottomSheet: _showBottomSheet
      //     ? BottomSheet(
      //         elevation: 10,
      //         backgroundColor: Colors.amber,
      //         enableDrag: false,
      //         onClosing: () {},
      //         builder: (BuildContext ctx) {
      //           return Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: InputItem(
      //               onTap: () {},
      //               returnItem: (p0) {
      //                 setState(() => _showBottomSheet = !_showBottomSheet);
      //               },
      //               dbList: _dbList,
      //             ),
      //           );
      //         },
      //       )
      //     : null,

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
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        // title //
                        ListTitle(
                          initialValue: _dbList.title,
                          onEditingComplete: (value) {
                            setState(() {
                              _dbList.title = value;
                              _dbList.save();
                            });
                          },
                        ),
                        // subtitle //
                        Text(
                          date,
                          style: txtStyle.bodySmall!.copyWith(color: Colors.grey),
                        ),
                        // lista  //
                        CrudList(
                          scrollCtlr: _scrollCtlr,
                          dbList: _dbList,
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

  void onCreateFloatingActionBtn() {
    createTaskBottomSheet(
      context: context,
      showClose: true,
      enableDrag: true,
      onClose: () {
        setState(() {
          toNewCategory = false;
          _showBottomSheet = !_showBottomSheet;
        });
      },
      child: InputItem(
        onTap: () {
          setState(() {
            _showBottomSheet = !_showBottomSheet;
          });
        },
        dbList: _dbList,
        returnItem: (value) {
          setState(() {
            scrollTo(0);
            toNewCategory ? idxInsert = _dbList.items.length - 1 : idxInsert = _dbList.items.length;
            if (value.isCategory) {
              toNewCategory = true;
              _dbList.items.add(value);
              _dbList.save();
            } else {
              _dbList.items.insert(idxInsert, value);
              _dbList.save();
            }
          });
        },
      ),
    );
  }

  void scrollTo(double offset) {
    _scrollCtlr.animateTo(
      offset,
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
    );
  }
}
