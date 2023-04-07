import 'package:flutter/material.dart';

import 'custom_circle_image.dart';

class ListViewItemBody extends StatelessWidget {
  const ListViewItemBody({
    Key? key,
    required this.userName,
    required this.taskCategory,
    required this.startTime,
    required this.title,
     required this.url ,
  }) : super(key: key);

  final String userName, taskCategory, startTime, title, url;

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
            blurRadius: 1,
            spreadRadius: .3,
            blurStyle: BlurStyle.inner,
            offset: const Offset(-8.5, -.1),
            color: Colors.blueAccent.withOpacity(.3),
          ),
          BoxShadow(
            blurRadius: 3,
            spreadRadius: .3,
            blurStyle: BlurStyle.normal,
            offset: const Offset(1, 2),
            color: Colors.grey.withOpacity(.3),
          ),
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
                      style: const TextStyle(color: Colors.red),
                      children: const [
                    WidgetSpan(
                        child: Icon(
                      Icons.calendar_month,
                      size: 20,
                    ))
                  ])),
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
              ),
            ],
          ),
          CustomCircleImage(
            url: url,
          ),
        ],
      ),
    );
  }
}
