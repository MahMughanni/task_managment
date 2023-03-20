import 'package:flutter/material.dart';
import 'package:task_mangment/utils/app_constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.onPressed,
      required this.title,
      required this.width,
      required this.height})
      : super(key: key);
  final Function()? onPressed;
  final String title;
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
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Colors.white,
            ),
      ),
    );
  }
}
