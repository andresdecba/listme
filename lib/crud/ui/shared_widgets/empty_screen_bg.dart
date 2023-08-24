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
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SvgPicture.asset(
              svgPath,
              alignment: Alignment.center,
              width: 100,
              color: Colors.grey.shade300,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                text,
                style: txtStyle.titleMedium!.copyWith(color: Colors.grey.shade300),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
