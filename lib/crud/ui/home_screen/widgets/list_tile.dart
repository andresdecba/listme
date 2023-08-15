import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.titleText,
    required this.subTitleText,
    required this.onTap,
    required this.onRemove,
  });

  final String titleText;
  final String subTitleText;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final TextTheme style = Theme.of(context).textTheme;
    final double widthScreen = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () => onTap(),
      child: Container(
        height: 70,
        width: widthScreen,
        margin: const EdgeInsets.symmetric(vertical: 2),
        //padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // PROGRESS //
            const SizedBox(width: 10),
            const _ProgressWidget(),
            const SizedBox(width: 20),

            // TEXT //
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
                      overflow: TextOverflow.ellipsis,
                      style: style.titleMedium,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      subTitleText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: style.bodySmall!.copyWith(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () => onRemove(),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                iconSize: 20,
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.grey,
                ),
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
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 2,
          color: Colors.cyan,
        ),
      ),
      child: const Text(
        '3/7',
        style: TextStyle(color: Colors.cyan),
      ),
    );
  }
}
