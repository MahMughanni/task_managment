import 'package:flutter/material.dart';
import 'package:task_mangment/admin/screen/admin_home_screen.dart';
import 'package:task_mangment/user/auth_layer/login_screen.dart';
import 'package:task_mangment/user/auth_layer/signup_screen.dart';
import 'package:task_mangment/user/auth_layer/splash_screen.dart';
import 'package:task_mangment/user/main_layer/main_screen.dart';
import 'package:task_mangment/user/main_layer/screens/calendar_screen/calender_screen.dart';
import 'package:task_mangment/user/main_layer/screens/company_tasks_screen/company_tasks.dart';
import 'package:task_mangment/user/main_layer/screens/setting_screen/pages/employee_screen.dart';
import 'package:task_mangment/user/main_layer/screens/setting_screen/pages/profile_screen.dart';
import 'package:task_mangment/user/main_layer/screens/setting_screen/pages/widgets/employee_detiails.dart';

import 'named_router.dart';

class OnGenerateRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case NamedRouter.mainScreen:
        page = MainScreen(
          userRole: settings.arguments as String ?? 'user',
        );
        break;

      case NamedRouter.loginScreen:
        page = const LoginScreen();
        break;
      case NamedRouter.companyTasks:
        page = CompanyTasksScreen();
        break;
      case NamedRouter.employeeDetailsScreen:
        page = EmployeeDetailsScreen(
          userData: settings.arguments as Map<String, dynamic>,
        );
        break;
      case NamedRouter.splashScreen:
        page = const SplashScreen();
        break;
      case NamedRouter.profileScreen:
        page = const ProfileScreen();
        break;
      case NamedRouter.calenderScreen:
        return MaterialPageRoute(builder: (BuildContext context) {
          final Map<String, dynamic>? args =
              settings.arguments as Map<String, dynamic>?;
          return CalendarScreen(
            userId: args?['userId'] ?? '',
            userName: args?['userName'] ?? '',
          );
        });
      case NamedRouter.employeeScreen:
        page = const EmployeeScreen();
        break;
      case NamedRouter.signUpScreen:
        page = const SignUpScreen();
        break;
      case NamedRouter.adminHomeScreen:
        page = AdminHomeScreen();
        break;
      default:
        page = const Scaffold(
          body: Center(
            child: Text(
              'Wrong path',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
    }
    return MaterialPageRoute(builder: (_) {
      return page;
    });
  }
}
