import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/commons/helpers.dart';
import 'package:listme/crud/models/item.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/shared_widgets/custom_bottomsheet.dart';
import 'package:listme/crud/ui/crud_screen/widgets/crud_list.dart';
import 'package:listme/crud/ui/shared_widgets/input_item.dart';
import 'package:listme/crud/ui/crud_screen/widgets/build_title.dart';
import 'package:uuid/uuid.dart';

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
  late Uuid _uuid;
  late bool _isCategory;
  int idxInsert = 0;
  bool toNewCategory = false;
  double bottomSpaceForScroll = 0.0;

  @override
  void initState() {
    super.initState();
    _box = Hive.box<Lista>(AppConstants.listasDb);
    _dbList = _box.get(widget.id)!;
    _scrollCtlr = ScrollController();
    _uuid = const Uuid();
    _isCategory = false;
  }

  @override
  Widget build(BuildContext context) {
    // variables //
    var date = Helpers.longDateFormater(_dbList.creationDate);
    final TextTheme txtStyle = Theme.of(context).textTheme;

    // scaffold //
    return Scaffold(
      // ADD LISTA BTN //
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () {
          setState(() {
            onCreateFloatingActionBtn();
          });
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
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        // title //
                        BuildTitle(
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
    customBottomSheet(
      context: context,
      showClose: true,
      enableDrag: true,
      onClose: () {
        toNewCategory = false;
      },
      child: Column(
        children: [
          CustomTextfield(
            onTap: () {},
            onEditingComplete: (value) {
              var newItem = Item(
                content: value,
                isDone: false,
                id: _uuid.v4(),
                isCategory: false,
              );

              scrollTo(0);
              toNewCategory ? idxInsert = _dbList.items.length - 1 : idxInsert = _dbList.items.length;
              if (_isCategory) {
                toNewCategory = true;
                _dbList.items.add(newItem);
                _dbList.save();
              }
              if (!_isCategory) {
                _dbList.items.insert(idxInsert, newItem);
                _dbList.save();
              }
            },
          ),
          CheckboxListTile(
            value: _isCategory,
            title: Text('crear sublista'),
            onChanged: (value) {
              setState(() {
                _isCategory = !_isCategory;
              });
            },
          ),
        ],
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
