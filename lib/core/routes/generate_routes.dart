import 'package:flutter/material.dart';
import 'package:task_mangment/screens/auth_layer/login_screen.dart';
import 'package:task_mangment/screens/auth_layer/signup_screen.dart';
import 'package:task_mangment/screens/main_layer/main_screen.dart';

import '../../screens/auth_layer/splash_screen.dart';
import '../../screens/main_layer/screens/home_screen/home_screen.dart';
import 'named_router.dart';

class OnGenerateRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    dynamic data = settings.arguments;

    Widget result;
    switch (settings.name) {
      case NamedRouter.mainScreen:
        result = const MainScreen();
        break;

      case NamedRouter.loginScreen:
        result = const LoginScreen();
        break;

      case NamedRouter.splashScreen:
        result = const SplashScreen();
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
