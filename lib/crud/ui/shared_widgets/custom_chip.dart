import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({
    this.iconData,
    required this.label,
    required this.onTap,
    required this.isEnabled,
    this.color,
    super.key,
  });

  final IconData? iconData;
  final String label;
  final VoidCallback onTap;
  final bool isEnabled;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    var iconColor = isEnabled ? Colors.grey : Colors.grey.shade300;
    final txtStyle = Theme.of(context).textTheme;

    return InkWell(
      splashColor: Colors.cyan.withOpacity(0.5),
      customBorder: const CircleBorder(),
      onTap: isEnabled ? () => onTap() : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: color ?? Colors.grey.withOpacity(0.5),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(iconData, size: 16, color: iconColor),
            const SizedBox(width: 8),
            Text(label, style: txtStyle.labelMedium!.copyWith(color: iconColor)),
          ],
        ),
      ),
    );
  }
}
