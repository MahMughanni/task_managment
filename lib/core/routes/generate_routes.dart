import 'package:flutter/material.dart';

import 'package:task_mangment/screens/auth_layer/login_screen.dart';
import 'package:task_mangment/screens/auth_layer/signup_screen.dart';
import 'package:task_mangment/screens/main_layer/main_screen.dart';
import 'package:task_mangment/screens/main_layer/screens/calender_screen/calender_screen.dart';
import 'package:task_mangment/screens/main_layer/screens/company_tasks_screen/company_tasks.dart';
import 'package:task_mangment/screens/main_layer/screens/setting_screen/pages/employee_screen.dart';
import 'package:task_mangment/screens/main_layer/screens/setting_screen/pages/profile_screen.dart';

import '../../screens/auth_layer/splash_screen.dart';
import 'named_router.dart';

class OnGenerateRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case NamedRouter.mainScreen:
        page = const MainScreen();
        break;

      case NamedRouter.loginScreen:
        page = const LoginScreen();
        break;
      case NamedRouter.companyTasks:
        page = CompanyTasksScreen();
        break;
      case NamedRouter.splashScreen:
        page = const SplashScreen();
        break;
      case NamedRouter.profileScreen:
        page = const ProfileScreen();
        break;
      case NamedRouter.calenderScreen:
        return MaterialPageRoute(builder: (BuildContext context) {
          return CalendarScreen(userId: settings.arguments?.toString() ?? '');
        });
      case NamedRouter.employeeScreen:
        page = EmployeeScreen();
        break;
      case NamedRouter.signUpScreen:
        page = const SignUpScreen();
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
    // return PageRouteBuilder(
    //   pageBuilder: (context, animation, secondaryAnimation) => page,
    //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //     var begin = const Offset(-1.0, 0.0); // slide from left to right
    //     var end = const Offset(0.0, 0.0);
    //     var tween = Tween<Offset>(
    //       begin: begin,
    //       end: end,
    //     );
    //     var curvedAnimation = CurvedAnimation(
    //       parent: animation,
    //       curve: Curves.fastOutSlowIn,
    //       reverseCurve: Curves.fastOutSlowIn,
    //     );
    //     return SlideTransition(
    //       position: tween.animate(curvedAnimation),
    //       child: child,
    //     );
    //   },
    // );
  }
}
