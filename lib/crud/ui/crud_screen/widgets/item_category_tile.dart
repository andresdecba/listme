import 'dart:async';

import 'package:flutter/material.dart';

class ItemCategoryTile extends StatefulWidget {
  const ItemCategoryTile({
    required this.text,
    required this.onAdd,
    required this.onRemove,
    super.key,
  });

  final String text;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  State<ItemCategoryTile> createState() => _ItemCategoryTileState();
}

class _ItemCategoryTileState extends State<ItemCategoryTile> {
  bool isRemove = false;
  Timer _timer = Timer(const Duration(seconds: 1), () {});

  @override
  Widget build(BuildContext context) {
    // remove
    final Widget removeBtn = IconButton(
      key: ValueKey(isRemove),
      visualDensity: VisualDensity.compact,
      onPressed: () {
        _timer.cancel();
        widget.onRemove();
      },
      icon: const Icon(
        Icons.close_rounded,
        color: Colors.red,
      ),
    );
    // add
    final Widget addBtn = IconButton(
      key: ValueKey(isRemove),
      visualDensity: VisualDensity.compact,
      onPressed: () => widget.onAdd(),
      icon: const Icon(
        Icons.add_rounded,
        color: Colors.black,
      ),
    );

    final txtStyle = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 25, 4, 2),
      child: Row(
        children: [
          ///
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => setState(() {
              if (!_timer.isActive) {
                isRemove = !isRemove;
                _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                  if (timer.tick == 5) {
                    setState(() {
                      isRemove = !isRemove;
                      _timer.cancel();
                    });
                  }
                });
              }
            }),
            icon: const Icon(
              Icons.circle,
              size: 15,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            widget.text,
            style: txtStyle.labelLarge!.copyWith(color: isRemove ? Colors.red.shade700 : Colors.black),
          ),

          ///
          const Spacer(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: isRemove ? removeBtn : addBtn,
          ),
        ],
      ),
    );
  }
}



/*
class ItemCategoryTile extends StatelessWidget {
  const ItemCategoryTile({
    required this.text,
    required this.onAdd,
    required this.onRemove,
    super.key,
  });

  final String text;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final txtStyle = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 2),
      
      child: Slidable(
        startActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (context) => onRemove(),
              icon: Icons.close_rounded,
              foregroundColor: Colors.grey.shade600,
              backgroundColor: Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
              autoClose: false,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
          child: Row(
            children: [
              const Icon(
                Icons.circle,
                size: 10,
              ),
              const SizedBox(width: 5),
              Text(
                text,
                style: txtStyle.labelLarge,
              ),
              const Spacer(),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () => onAdd(),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/