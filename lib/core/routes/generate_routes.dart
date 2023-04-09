import 'package:flutter/material.dart';

import 'package:task_mangment/screens/auth_layer/login_screen.dart';
import 'package:task_mangment/screens/auth_layer/signup_screen.dart';
import 'package:task_mangment/screens/main_layer/main_screen.dart';
import 'package:task_mangment/screens/main_layer/screens/company_tasks_screen/company_tasks.dart';
import 'package:task_mangment/screens/main_layer/screens/setting_screen/pages/employee_screen.dart';
import 'package:task_mangment/screens/main_layer/screens/setting_screen/pages/profile_screen.dart';

import '../../screens/auth_layer/splash_screen.dart';
import 'named_router.dart';

class OnGenerateRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // dynamic data = settings.arguments;

    Widget result;
    switch (settings.name) {
      case NamedRouter.mainScreen:
        result = const MainScreen();
        break;

      case NamedRouter.loginScreen:
        result = const LoginScreen();
        break;
      case NamedRouter.companyTasks:
        result = CompanyTasksScreen();
        break;
      // case NamedRouter.taskDetailsScreen:
      //   if (data is TaskModel) {
      //     final selectedTask = data as TaskModel;
      //     result = TaskDetailsScreen(taskStream: Stream.value([selectedTask]));
      //   } else {
      //     result = const Center(child: Text('Invalid task data'));
      //   }
      //   break;

      case NamedRouter.splashScreen:
        result = const SplashScreen();
        break;
      case NamedRouter.profileScreen:
        result = const ProfileScreen();
        break;
      case NamedRouter.employee:
        result = const EmployeeScreen();
        break;
      case NamedRouter.signUpScreen:
        result = const SignUpScreen();
        break;

      default:
        result = const Scaffold(
          body: Center(
            child: Text(
              'Wrong path',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
    }
    return MaterialPageRoute(builder: (context) => result);
  }
}
