import 'package:flutter/material.dart';
import 'package:task_mangment/utils/app_constants.dart';

class ListVIewItemBody extends StatelessWidget {
  const ListVIewItemBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(-8, 0),
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
            children: const [
              Text('Task category'),
              Text('Task name'),
              Text('6.Feb.2023'),
              Text('Assigned employee'),
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
