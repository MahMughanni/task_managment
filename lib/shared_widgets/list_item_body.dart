import 'package:flutter/material.dart';
import 'package:task_mangment/utils/app_constants.dart';

class ListViewItemBody extends StatelessWidget {
  const ListViewItemBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      padding: const EdgeInsets.all(8),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
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
              const Text('Task category'),
              RichText(
                  text: TextSpan(
                      text: 'UserName  ',
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
                  text: const TextSpan(
                      text: '6.Feb.2023 ',
                      style: TextStyle(color: Colors.red),
                      children: [
                    WidgetSpan(
                        child: Icon(
                      Icons.calendar_month,
                      size: 20,
                    ))
                  ])),
              const Text('Assigned employee'),
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
