import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_mangment/utils/app_constants.dart';

ThemeData getAppTheme() => ThemeData(
      fontFamily: 'Cairo',
      useMaterial3: true,
      iconTheme: const IconThemeData(color: Colors.black),
      textTheme: getTextTheme(),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedIconTheme: IconThemeData(color: Colors.grey.shade700),
          selectedIconTheme:
              const IconThemeData(color: ColorConstManger.primaryColor)),
    );

TextTheme getTextTheme() => TextTheme(
      titleLarge: TextStyle(
        fontSize: 24.sp,
        fontWeight: AppConstFontWeight.semiBold,
        color: ColorConstManger.primaryColor,
      ),
      titleMedium: TextStyle(
        fontSize: 20.sp,
        fontWeight: AppConstFontWeight.semiBold,
        color: ColorConstManger.black,
      ),
      titleSmall: TextStyle(
        fontSize: 18.sp,
        fontWeight: AppConstFontWeight.semiBold,
        color: ColorConstManger.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 18.sp,
        fontWeight: AppConstFontWeight.medium,
        color: ColorConstManger.primaryColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 16.sp,
        fontWeight: AppConstFontWeight.regular,
        color: ColorConstManger.primaryColor,
      ),
      bodySmall: TextStyle(
        fontSize: 14.sp,
        fontWeight: AppConstFontWeight.regular,
        color: ColorConstManger.primaryColor,
      ),
    );
