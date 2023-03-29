import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    Key? key,
    this.child,
    this.color = Colors.grey,
  }) : super(key: key);
  final Widget? child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.all(6),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
      height: height * .1,
      width: width * .29,
      child: child,
    );
  }
}
