import 'package:flutter/material.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();


  static final GlobalKey<ScaffoldMessengerState> snackBarKey =
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

  static void goBackWithAnimation(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => Container(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  static goTo({required String screenName, Object? arguments}) {
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
