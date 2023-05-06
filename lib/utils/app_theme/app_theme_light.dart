import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_mangment/utils/app_constants.dart';

ThemeData getAppTheme() => ThemeData(
      iconTheme: const IconThemeData(color: Colors.black),
      textTheme: getTextTheme(),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedIconTheme: IconThemeData(color: Colors.grey.shade700),
          selectedIconTheme:
              const IconThemeData(color: ColorConstManger.primaryColor)),
    );

TextTheme getTextTheme() =>  TextTheme(
      titleLarge: TextStyle(
        fontSize: 32.sp,
        fontWeight: AppConstFontWeight.bold,
        color: ColorConstManger.primaryColor,
      ),
    );
