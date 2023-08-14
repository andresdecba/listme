import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.titleText,
    required this.subTitleText,
    required this.onTap,
    required this.keyId,
    required this.onRemove,
  });

  final String titleText;
  final String subTitleText;
  final VoidCallback onTap;
  final String keyId;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;
    final double widthScreen = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () => onTap(),
      child: Container(
        height: 70,
        width: widthScreen,
        margin: const EdgeInsets.symmetric(vertical: 2),
        //padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.cyan,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 10),
            const _ProgressWidget(),
            const SizedBox(width: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      titleText,
                      maxLines: 2,
                      overflow: TextOverflow.fade,
                      style: style.bodyLarge,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      subTitleText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: style.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => onRemove(),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                iconSize: 20,
                icon: const Icon(Icons.close_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressWidget extends StatelessWidget {
  const _ProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
    );
  }
}
