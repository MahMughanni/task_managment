import 'package:flutter/material.dart';
import 'package:task_mangment/utils/app_constants.dart';

import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    goToLoginScreen(context);

    return Scaffold(
      body: Center(
        child: Image.asset(ImageConstManger.logoImage),
      ),
    );
  }

  void goToLoginScreen(context) async {
    await Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) {
          return const LoginScreen();
        }),
      );
    });
  }
}
