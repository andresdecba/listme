import 'package:flutter/material.dart';

class ListSeparator extends StatelessWidget {
  const ListSeparator({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        const Icon(
          Icons.circle,
          size: 15,
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
