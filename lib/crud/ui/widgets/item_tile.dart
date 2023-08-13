import 'package:flutter/material.dart';

class ItemTile extends StatefulWidget {
  const ItemTile({
    required this.onTapIsDone,
    required this.onRemove,
    required this.text,
    required this.isDone,
    super.key,
  });

  final VoidCallback onRemove;
  final VoidCallback onTapIsDone;
  final String text;
  final bool isDone;

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  final _duration500 = const Duration(milliseconds: 500);
  final _duration300 = const Duration(milliseconds: 400);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: _duration300,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      decoration: BoxDecoration(
        color: widget.isDone ? Colors.cyan.shade100 : Colors.cyan.shade300,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // is done btn //
                AnimatedSwitcher(
                  duration: _duration500,
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: IconButton(
                    key: ValueKey(widget.isDone),
                    onPressed: () => widget.onTapIsDone(),
                    icon: Icon(
                      widget.isDone ? Icons.check_circle_rounded : Icons.circle_outlined,
                      color: Colors.grey.shade600,
                    ),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    iconSize: 20,
                  ),
                ),
                // txt //
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 5, 8),
                    child: Text(
                      widget.text,
                      style: TextStyle(
                        color: widget.isDone ? Colors.grey.shade600 : Colors.black,
                        decoration: widget.isDone ? TextDecoration.lineThrough : TextDecoration.none,
                        decorationColor: widget.isDone ? Colors.grey.shade600 : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // remove btn //
          AnimatedSwitcher(
            duration: _duration500,
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: widget.isDone
                ? SizedBox(
                    height: 25,
                    width: 25,
                    child: IconButton(
                      key: ValueKey(widget.isDone),
                      onPressed: () => widget.onRemove(),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      iconSize: 20,
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                    ),
                  )
                : SizedBox(
                    key: ValueKey(widget.isDone),
                  ),
          ),
        ],
      ),
    );
  }
}
