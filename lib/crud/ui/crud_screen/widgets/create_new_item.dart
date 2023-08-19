import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:listme/core/commons/typedefs.dart';
import 'package:listme/crud/models/item.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:listme/crud/ui/shared_widgets/custom_bottomsheet.dart';
import 'package:listme/crud/ui/shared_widgets/input_item.dart';
import 'package:uuid/uuid.dart';

mixin CreateNewItem {
  final Uuid uuid = const Uuid();
  bool isSublist = false;
  int sublistIndex = 0;
  String? subListName;

  void scrollTo(
    double offset,
    ScrollController scrollCtlr,
  ) {
    scrollCtlr.animateTo(
      offset,
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
    );
  }

  void onCreateNewItem({
    required BuildContext context,
    required Lista lista,
    required ScrollController scrollCtlr,
    int? indexUnderSublist,
  }) {
    if (indexUnderSublist != null) {
      subListName = lista.items[indexUnderSublist].content;
    }

    customBottomSheet(
      context: context,
      showClose: true,
      enableDrag: true,
      title: indexUnderSublist != null ? 'Add a new item under:' : 'Add a new item on top',
      subTitle: subListName,
      onClose: () {},
      child: Column(
        children: [
          //
          // TEXT INPUT //
          CustomTextfield(
            onTap: () {},
            onEditingComplete: (value) {
              // crear un nuevo item
              var newItem = Item(
                content: value,
                isDone: false,
                id: uuid.v4(),
                isCategory: isSublist,
              );

              // insertar el item abajo de una categoria
              if (!isSublist && indexUnderSublist != null) {
                lista.items.insert(indexUnderSublist + 1, newItem);
                lista.save();
              }

              // insertar el item sin categoria (arriba de la lista)
              if (!isSublist && indexUnderSublist == null) {
                lista.items.insert(0, newItem);
                lista.save();
                scrollTo(0, scrollCtlr);
              }

              // insertar la categoria abajo del último item sin categoria
              if (isSublist) {
                if (lista.items.isNotEmpty) {
                  bool isAnySublist = false;
                  // si hay alguna sub en la lista
                  for (var element in lista.items) {
                    if (element.isCategory) {
                      isAnySublist = true;
                      sublistIndex = lista.items.indexOf(element);
                      break;
                    }
                  }
                  // si no hay ninguna sub
                  if (!isAnySublist) {
                    sublistIndex = lista.items.length;
                  }
                }
                lista.items.insert(sublistIndex, newItem);
                lista.save();
                isSublist = false;
                context.pop();
              }
            },
          ),

          // CHECK BOX LIST //
          _CustomCheckboxList(
            value: (bool value) {
              isSublist = value;
            },
          ),
        ],
      ),
    );
  }
}

class _CustomCheckboxList extends StatefulWidget {
  const _CustomCheckboxList({
    required this.value,
  });
  final ReturnBool value;

  @override
  State<_CustomCheckboxList> createState() => _CustomCheckboxListState();
}

class _CustomCheckboxListState extends State<_CustomCheckboxList> {
  bool _theValue = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      value: _theValue,
      title: const Text('crear sublista'),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (bool? value) {
        setState(() {
          _theValue = !_theValue;
          widget.value(value!);
        });
      },
    );
  }
}
