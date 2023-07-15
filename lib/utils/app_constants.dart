import 'package:flutter/material.dart';

const String imagePath = 'assets/images';
const String iconsPath = 'assets/icons';
const String animationsPath = 'assets/animations';

class ImageConstManger {
  static const String logoImage = '$imagePath/logo.png';
  static const String profileImage = '$imagePath/profile.png';
  static const String logoutImage = '$imagePath/logout.png';
  static const String emailImage = '$imagePath/email.png';
  static const String aboutUsImage = '$imagePath/about.png';
  static const String langImage = '$imagePath/lang.png';
  static const String noInternet = '$animationsPath/disconnected_network.json';
}

class SvgIconsConstManger {
  static const String phone = '$iconsPath/phone.svg';
  static const String whatsapp = '$iconsPath/whatsapp.svg';
  static const String email = '$iconsPath/email.svg';
  static const String done = '$iconsPath/done.svg';
  static const String calender = '$iconsPath/calender.svg';
  static const String profileImage = '$iconsPath/profile.svg';
  static const String logoutImage = '$iconsPath/logout.svg';
  static const String employeeImage = '$iconsPath/employee.svg';
  static const String aboutUsImage = '$iconsPath/about.svg';
  static const String langImage = '$iconsPath/lang.svg';
  static const String location = '$iconsPath/location.svg';
}

class ColorConstManger {
  static const Color primaryColor = Color(0xff218BDB);
  static const Color formFieldFiledColor = Color(0xffF2F2F2);
  static const int backGroundBottomSheet = 0xFF505050;
  static const int backGroundContainer = 0xffFFF9F0;
  static const int borderContainer = 0xffF3F3F3;
  static const Color titleTextFormFieldColor = Color(0xFF6C6969);
  static const Color lightGrey = Color(0xFF707070);
  static const Color primaryBorder = Color(0xFF4375FF);
  static const Color borderBlue = Color(0xFF90AEFF);
  static Color greyIconBorder = const Color(0xFF8C8C8C);
  static const Color borderWhite = Color(0xFFE2E2E2);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const int backGroundSnackBarFalse = 0xFFFCF3E4;
  static const int borderSnackBarFalse = 0xFFDAA545;
  static const int backGroundSnackBarTrue = 0xFFE9F7E7;
  static const int primaryTextColor = 0xFF000000;
  static const int primaryButtonColor = 0xFF4375FF;
  static const int borderSnackBarTrue = 0xFF70B668;
  static const Color red = Colors.red;
}

class AppConstFontWeight {
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight mostThick = FontWeight.w900;
}
