import 'package:flutter/material.dart';

// HEAD //
class DrawerHead extends StatelessWidget {
  const DrawerHead({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final TextTheme txtStyle = Theme.of(context).textTheme;
    return Container(
      height: 150,
      alignment: Alignment.center,
      child: Text(
        text,
        style: txtStyle.titleMedium,
      ),
    );
  }
}

// TILE //
class DrawerTile extends StatelessWidget {
  const DrawerTile({
    required this.texto,
    required this.onTap,
    this.leading,
    this.border,
    super.key,
  });

  final String texto;
  final VoidCallback onTap;
  final BoxBorder? border;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final TextTheme style = Theme.of(context).textTheme;
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          border: border,
        ),
        child: Row(
          children: [
            leading != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: leading,
                  )
                : const SizedBox.shrink(),
            Expanded(
              child: Text(
                texto,
                style: style.titleSmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
