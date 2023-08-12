import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({
    super.key,
    required this.onTapIsDone,
    required this.onRemove,
    required this.text,
    required this.isDone,
  });

  final VoidCallback onRemove;
  final VoidCallback onTapIsDone;
  final String text;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: isDone ? Colors.cyan.shade100 : Colors.cyan.shade300,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => onTapIsDone(),
                  icon: isDone
                      ? Icon(
                          Icons.check_circle_rounded,
                          color: Colors.grey.shade600,
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
                        color: isDone ? Colors.grey.shade600 : Colors.black,
                        decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                        decorationColor: isDone ? Colors.grey.shade600 : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: isDone,
            replacement: const SizedBox(
              width: 40,
            ),
            child: IconButton(
              onPressed: () => onRemove(),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              iconSize: 20,
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
