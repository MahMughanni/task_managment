import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_circle_image.dart';

class ListViewItemBody extends StatelessWidget {
  const ListViewItemBody({
    Key? key,
    required this.userName,
    required this.taskCategory,
    required this.startTime,
    required this.title,
    required this.url,
  }) : super(key: key);

  final String userName, taskCategory, startTime, title, url;

  @override
  Widget build(BuildContext context) {
    int maxLength = 20;
    var screenSize = MediaQuery.of(context).size;

    String shortString = title.length > maxLength
        ? "${title.substring(0, maxLength)}..."
        : title;
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: screenSize.height * .11.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: .1,
            blurStyle: BlurStyle.inner,
            offset: const Offset(-5, .1),
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
        borderRadius: BorderRadius.circular(10).r,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 0.0, left: 16, right: 8).r,
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
                    style: TextStyle(
                        color: Colors.black, overflow: TextOverflow.ellipsis,
                    fontSize: 14.sp, ),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
                RichText(
                  text: TextSpan(
                      text: startTime,
                      style: const TextStyle(color: Colors.red),
                      children:  [
                        WidgetSpan(
                            child: Icon(
                          Icons.calendar_month,
                          size: 15.r,
                        ))
                      ]),
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
                Text(
                  shortString,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(fontSize: 16, color: Colors.blueAccent),
                ),
              ],
            ),
            CustomCircleImage(
              image: url,
              width: 50.w,
              height: 50.h,
            ),
          ],
        ),
      ),
    );
  }
}
