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
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: isDone ? Colors.cyan.shade300.withOpacity(0.5) : Colors.cyan.shade300,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => onTapIsDone(),
            icon: isDone
                ? Icon(
                    Icons.check_circle_rounded,
                    color: Colors.black.withOpacity(0.5),
                  )
                : const Icon(Icons.circle_outlined),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            iconSize: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                text,
                style: TextStyle(
                  color: isDone ? Colors.black.withOpacity(0.5) : Colors.black,
                  decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                  decorationColor: isDone ? Colors.black.withOpacity(0.5) : Colors.black,
                ),
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
              icon: Icon(
                Icons.close_rounded,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
