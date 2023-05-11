import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_mangment/core/routes/app_router.dart';
import 'package:task_mangment/core/routes/named_router.dart';
import 'package:task_mangment/screens/auth_layer/controller/authentication_cubit.dart';
import 'package:task_mangment/utils/app_constants.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkLoginStatus();
    super.initState();
  }

  Future<void> checkLoginStatus() async {
    await BlocProvider.of<AuthenticationCubit>(context).autoLogin();

    if (BlocProvider.of<AuthenticationCubit>(context).loggedInUser != null) {
      AppRouter.goToAndRemove(routeName: NamedRouter.mainScreen);

    } else {
      AppRouter.goToAndRemove(routeName: NamedRouter.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(ImageConstManger.logoImage),
      ),
    );
  }
}
