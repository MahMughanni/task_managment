import 'package:flutter/material.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  static void goToAndRemove({required String routeName, Object? arguments}) {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        routeName,
        (route) => false, // remove all previous routes
        arguments: arguments,
      );
    }
  }

  static goTo({required String screenName, Object? arguments}) {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.pushNamed(screenName, arguments: arguments);
    }
  }

  static goToWithManyArguments({required String screenName, Map<String, dynamic>? arguments}) {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.pushNamed(screenName, arguments: arguments);
    }
  }

  static mayBack() {
    navigatorKey.currentState!.maybePop();
  }

  static removeAllBack({required String screenName}) {
    navigatorKey.currentState!
        .pushNamedAndRemoveUntil(screenName, (Route<dynamic> route) => false);
  }
}
