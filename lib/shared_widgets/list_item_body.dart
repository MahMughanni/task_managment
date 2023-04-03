import 'package:flutter/material.dart';
import 'package:task_mangment/utils/app_constants.dart';

class ListViewItemBody extends StatelessWidget {
  const ListViewItemBody(
      {Key? key,
      required this.userName,
      required this.taskCategory,
      required this.startTime,
      required this.title})
      : super(key: key);

  final String userName, taskCategory, startTime, title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(6),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: .5,
            spreadRadius: .5,
            offset: const Offset(-10, 0),
            color: Colors.blueAccent.withOpacity(.4),
          )
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(taskCategory),
              RichText(
                  text: TextSpan(
                      text: userName,
                      style: const TextStyle(color: Colors.black),
                      children: [
                    WidgetSpan(
                        child: Icon(
                      Icons.messenger,
                      color: Colors.green.shade100,
                      size: 19,
                    ))
                  ])),
              RichText(
                  text: TextSpan(
                      text: startTime,
                      style: TextStyle(color: Colors.red),
                      children: [
                    WidgetSpan(
                        child: Icon(
                      Icons.calendar_month,
                      size: 20,
                    ))
                  ])),
              Text(title),
            ],
          ),
          CircleAvatar(
            radius: 25,
            child: Image.asset(ImageConstManger.logoImage),
          )
        ],
      ),
    );
  }
}
