import 'package:flutter/material.dart';

class TileSublist extends StatelessWidget {
  const TileSublist({
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
      padding: const EdgeInsets.fromLTRB(0, 25, 4, 2),
      child: Row(
        children: [
          // LEADING ICON //
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => onAdd(),
            icon: const Icon(
              Icons.circle,
              size: 15,
            ),
          ),
          const SizedBox(width: 5),

          // TEXT //
          Expanded(
            child: Text(
              text,
              style: txtStyle.labelLarge,
            ),
          ),

          // TRAILING //
          // remove
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => onRemove(),
            icon: Icon(
              Icons.delete_forever,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(width: 5),
          // add
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => onAdd(),
            icon: const Icon(
              Icons.add_rounded,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
