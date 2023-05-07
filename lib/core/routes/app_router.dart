import 'package:flutter/material.dart';

import 'named_router.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static goToAndRemove({required String screenName, Object? arguments}) {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!
          .pushReplacementNamed(screenName, arguments: arguments);
    }
  }

  static void goToAndRemoveNamedWithAnimation({
    required String routeName,
    Object? arguments,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeInOut,
  }) {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.pushReplacementNamed(
        routeName,
        arguments: arguments,
        result: arguments,
      );
      // Add custom transition animation
      final Route<dynamic> newRoute = PageRouteBuilder(
        transitionDuration: duration,
        pageBuilder: (context, animation, secondaryAnimation) =>
        NamedRouter.routes[routeName]!,
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: curve),
          ),
          child: child,
        ),
      );
      navigatorKey.currentState!.pushAndRemoveUntil(newRoute, (route) => false);
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
