import 'package:flutter/material.dart';

class ItemCategoryTile extends StatelessWidget {
  const ItemCategoryTile({
    required this.text,
    required this.onTap,
    super.key,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final txtStyle = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 25, 5, 0),
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
            onPressed: () => onTap(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
