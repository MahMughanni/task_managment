import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    Key? key,
    this.color = Colors.grey,
    required this.titel,
    required this.taskNumber,
  }) : super(key: key);
  final Color? color;
  final String titel, taskNumber;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(6),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
      height: height * .1,
      width: width * .29,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(titel , style: Theme.of(context).textTheme.titleMedium,),
          Text(taskNumber),
        ],
      ),
    );
  }
}
