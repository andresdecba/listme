import 'package:chip_list/chip_list.dart';
import 'package:flutter/material.dart';
import 'package:listme/core/commons/typedefs.dart';
import 'package:listme/crud/models/item.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:uuid/uuid.dart';

class InputItem extends StatefulWidget {
  const InputItem({
    required this.returnItem,
    required this.dbList,
    Key? key,
  }) : super(key: key);

  final ReturnItem returnItem;
  final Lista dbList;

  @override
  State<InputItem> createState() => _InputItemState();
}

class _InputItemState extends State<InputItem> {
  late GlobalKey<FormState> formStateKey;
  late FocusNode focusNode;
  late TextEditingController textController;
  late Uuid _uuid;
  int counter = 0;
  bool isCategory = false;
  // chips
  int currentIndex = 0;
  List<Item> listOfChips = [];

  @override
  void initState() {
    super.initState();
    formStateKey = GlobalKey<FormState>();
    focusNode = FocusNode();
    textController = TextEditingController();
    _uuid = const Uuid();
    if (widget.dbList.items.isNotEmpty) {
      for (var e in widget.dbList.items) {
        if (e.isCategory) {
          listOfChips.add(e);
        }
      }
    }

    textController.addListener(() {
      setState(() {
        counter = textController.text.length;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final txtStyle = Theme.of(context).textTheme;

    final item = Item(
      content: textController.text,
      isDone: false,
      id: _uuid.v4(),
      isCategory: isCategory,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FORMULARIO //
          Form(
            key: formStateKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              //textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              focusNode: focusNode,
              autofocus: true,
              controller: textController,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.sentences,
              style: Theme.of(context).textTheme.titleLarge!,
              maxLines: null,
              maxLength: 120,
              validator: (value) {
                if (value != null && value.length < 3) {
                  return 'Between 3 and 120 characters';
                } else {
                  return null;
                }
              },
              onEditingComplete: () {
                if (formStateKey.currentState!.validate()) {
                  widget.returnItem(item);
                  textController.clear();
                  isCategory = false;
                }
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                isDense: true,
                border: const OutlineInputBorder(),
                hintText: 'description',
                // styles
                // hintStyle: kBodySmall.copyWith(fontStyle: FontStyle.italic, color: disabledGrey, fontWeight: FontWeight.normal, fontSize: 13),
                // helperStyle: kBodySmall.copyWith(fontStyle: FontStyle.italic, color: disabledGrey, fontWeight: FontWeight.normal),
                // errorStyle: kBodySmall.copyWith(fontStyle: FontStyle.italic, color: disabledGrey, fontWeight: FontWeight.normal),
                // counterStyle: kBodySmall.copyWith(
                //   fontStyle: FontStyle.italic,
                //   fontWeight: controller.counter.value < 6 ? FontWeight.bold : FontWeight.normal,
                //   color: controller.counter.value < 6 ? warning : disabledGrey,
                // ),
                // others
                suffixIcon: counter == 0
                    ? null
                    : InkWell(
                        onTap: () => textController.clear(),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: Icon(
                            Icons.close_rounded,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                suffixIconConstraints: const BoxConstraints(maxHeight: 100),
                filled: true,
                fillColor: Colors.grey.shade200,

                // counter
                counterText: "$counter",
                counterStyle: const TextStyle(color: Colors.grey),
                // border
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                // helper
                helperText: 'between 3 and 120 characters',
                helperStyle: const TextStyle(color: Colors.grey),
                // error
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 1.0),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                ),
              ),
            ),
          ),

          // CREAR CATEGORIA //
          //const Divider(),
          CheckboxListTile(
            value: isCategory,
            onChanged: (value) {
              setState(() {
                isCategory = value!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: const Text('Create category'),
            //secondary: const Icon(Icons.category),
          ),

          // CHIPS //
          // ChipList(
          //   shouldWrap: false,
          //   listOfChipNames: listOfChips.map((e) => e.content).toList(),
          //   inactiveBgColorList: [Colors.grey.shade300],
          //   inactiveTextColorList: [Colors.grey.shade500],
          //   inactiveBorderColorList: [Colors.grey.shade300],
          //   activeBgColorList: const [Colors.cyan],
          //   activeTextColorList: const [Colors.black],
          //   activeBorderColorList: const [Colors.cyan],
          //   borderRadiiList: const [20],
          //   style: txtStyle.bodySmall,
          //   listOfChipIndicesCurrentlySeclected: [currentIndex], // no modificar, ver documentación
          //   extraOnToggle: (i) {
          //     setState(() {
          //       currentIndex = i;
          //     });
          //   },
          // ),
        ],
      ),
    );
  }
}
