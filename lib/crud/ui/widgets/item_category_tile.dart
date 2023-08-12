import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
