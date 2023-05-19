import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    Key? key,
    this.color = Colors.grey,
    required this.title,
    required this.taskNumber,
    this.height,
    this.width,
    this.onTap,
  }) : super(key: key);
  final Color? color;
  final String title, taskNumber;
  final double? height, width;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(4).r,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15).r,
        ),
        height: height ?? ScreenUtil().setHeight(90),
        width: width ?? ScreenUtil().setWidth(105),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp, color: Colors.black),
            ),
            Text(
              taskNumber,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 14.sp, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
