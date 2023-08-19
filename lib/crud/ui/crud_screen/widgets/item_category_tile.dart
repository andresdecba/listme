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
