import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({
    super.key,
    required this.onTapIsDone,
    required this.onTapClose,
    required this.text,
    required this.isDone,
  });

  final VoidCallback onTapClose;
  final VoidCallback onTapIsDone;
  final String text;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.cyan.shade300,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => onTapIsDone(),
            icon: isDone ? const Icon(Icons.check_circle_rounded) : const Icon(Icons.circle_outlined),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            iconSize: 20,
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                //color: isDone ? Colors.grey.shade500 : Colors.grey,
                decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                decorationColor: isDone ? Colors.grey.shade500 : Colors.grey,
              ),
            ),
          ),
          Visibility(
            visible: isDone,
            child: IconButton(
              onPressed: () => onTapClose(),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              iconSize: 20,
              icon: const Icon(Icons.close_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
