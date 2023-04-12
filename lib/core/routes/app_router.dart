import 'package:flutter/material.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static goToAndRemove({required String screenName, Object? arguments}) {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!
          .pushReplacementNamed(screenName, arguments: arguments);
    }
  }

  static goTo({required String screenName, Object? arguments}) {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.pushNamed(screenName, arguments: arguments);
    }
  }

  static back() {
    navigatorKey.currentState!.pop();
  }

  static mayBack() {
    navigatorKey.currentState!.maybePop();
  }

  static removeAllBack({required String screenName}) {
    navigatorKey.currentState!
        .pushNamedAndRemoveUntil(screenName, (Route<dynamic> route) => false);
  }
}
