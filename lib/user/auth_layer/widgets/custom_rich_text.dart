import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  const CustomRichText({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.tapGestureRecognizer,
    required this.padding,
    required this.subTextStyle,
    required this.titleStyle,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final TapGestureRecognizer tapGestureRecognizer;
  final EdgeInsetsGeometry padding;
  final TextStyle subTextStyle;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: RichText(
        text: TextSpan(
          text: title,
          style: titleStyle,
          children: [
            TextSpan(
              text: subTitle,
              style: subTextStyle,
              recognizer: tapGestureRecognizer,
            )
          ],
        ),
      ),
    );
  }
}
