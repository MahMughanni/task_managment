import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    Key? key,
    this.color = Colors.grey,
    required this.title,
    required this.taskNumber,
  }) : super(key: key);
  final Color? color;
  final String title, taskNumber;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(4).r,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
      height: height * .15.h,
      width: width * .25.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14.sp),
          ),
          Text(taskNumber),
        ],
      ),
    );
  }
}
