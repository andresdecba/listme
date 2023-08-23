import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyScreenBg extends StatelessWidget {
  const EmptyScreenBg({
    required this.svgPath,
    required this.text,
    super.key,
  });

  final String text;
  final String svgPath;

  @override
  Widget build(BuildContext context) {
    final TextTheme txtStyle = Theme.of(context).textTheme;

    return FadeIn(
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 1.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgPath,
              alignment: Alignment.center,
              width: 100,
              color: Colors.grey.shade300,
            ),
            Text(
              text,
              style: txtStyle.titleMedium!.copyWith(color: Colors.grey.shade300),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
