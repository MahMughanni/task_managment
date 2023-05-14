import 'package:flutter/material.dart';
import 'package:task_mangment/screens/auth_layer/login_screen.dart';
import 'package:task_mangment/screens/auth_layer/signup_screen.dart';
import 'package:task_mangment/screens/auth_layer/splash_screen.dart';
import 'package:task_mangment/screens/main_layer/main_screen.dart';
import 'package:task_mangment/screens/main_layer/screens/company_tasks_screen/company_tasks.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/home_screen.dart';
import 'package:task_mangment/screens/main_layer/screens/setting_screen/pages/employee_screen.dart';
import 'package:task_mangment/screens/main_layer/screens/setting_screen/pages/profile_screen.dart';
import 'package:task_mangment/screens/main_layer/screens/task_details_screen/task_details_screen.dart';


class NamedRouter {
  static const String splashScreen = '/';
  static const String homeScreen = '/home_screen';
  static const String loginScreen = '/login_screen';
  static const String signUpScreen = '/signup_screen';
  static const String mainScreen = '/main_screen';
  static const String companyTasks = '/company_tasks';
  static const String taskDetailsScreen = '/task_details';
  static const String profileScreen = '/profile';
  static const String employeeScreen = '/employee';
  static const String calenderScreen = '/calender';
  static const String employeeDetailsScreen = '/EmployeeDetails';
}
