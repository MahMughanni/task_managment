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

    String shortString = title.length > maxLength
        ? "${title.substring(0, maxLength)}..."
        : title;
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8).r,
      height: ScreenUtil().setHeight(110),
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
        padding: const EdgeInsets.only(left: 16, right: 8).r,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  taskCategory,
                  style: TextStyle(fontSize: 13.sp),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: userName,
                      style: TextStyle(
                        color: Colors.black,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 15.sp,
                      ),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                  ),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                        text: startTime,
                        style: const TextStyle(color: Colors.red),
                        children: [
                          WidgetSpan(
                              child: Icon(
                            Icons.calendar_month,
                            size: 15.r,
                          ))
                        ]),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ),
                Text(
                  shortString,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14.sp, color: Colors.blueAccent),
                ),
                4.verticalSpace,
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
