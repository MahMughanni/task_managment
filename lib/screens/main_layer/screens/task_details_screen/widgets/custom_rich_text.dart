import 'package:flutter/material.dart';

import '../../../../../utils/app_constants.dart';

class CustomDetailsRichText extends StatelessWidget {
  const CustomDetailsRichText(
      {Key? key,
      required this.title,
      required this.titleStyle,
      required this.subTitle,
      this.subTitleStyle})
      : super(key: key);

  final String title, subTitle;

  final TextStyle titleStyle;
  final TextStyle? subTitleStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text.rich(
        TextSpan(
          text: title,
          style: titleStyle,
          children: [
            TextSpan(
              text: subTitle ,
              style: subTitleStyle ??
                  TextStyle(
                    color: Colors.green.withOpacity(.8),
                    fontWeight: AppConstFontWeight.normal,
                    fontSize: 18,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
