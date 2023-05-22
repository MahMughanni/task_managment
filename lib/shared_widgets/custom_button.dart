import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/utils/app_constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.onPressed,
      required this.title,
      required this.width,
      required this.height})
      : super(key: key);
  final Function()? onPressed;
  final Object title;
  final double width, height;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          minimumSize: Size(width, height),
          backgroundColor: ColorConstManger.primaryColor),
      onPressed: onPressed,
      child: Text(
        title.toString(),
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
          fontSize: 16.sp,
              color: Colors.white,
            ),
      ),
    );
  }
}
