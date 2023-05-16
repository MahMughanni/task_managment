import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_mangment/utils/app_constants.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          ImageConstManger.logoImage,
          fit: BoxFit.contain,
          height: height / 4.h,
          width: width / 2.h,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 24.sp,
                ),
          ),
        ),
      ],
    );
  }
}
