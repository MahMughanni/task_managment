import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_mangment/user/auth_layer/controller/authentication_cubit.dart';
import 'package:task_mangment/user/auth_layer/widgets/header_widget.dart';
import 'package:task_mangment/user/auth_layer/widgets/login_body_widget.dart';
import 'package:task_mangment/utils/extentions/padding_extention.dart';
import 'package:task_mangment/utils/utils_config.dart';
import '../main_layer/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late AuthenticationCubit authCubit;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    authCubit = BlocProvider.of<AuthenticationCubit>(context);
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if (state is LoginInProgress) {
              UtilsConfig.showSnackBarMessage(message: 'loading', status: false);
            }
            if (state is LoginFailure) {
              debugPrint(state.errorMessage.toString());
              UtilsConfig.showSnackBarMessage(
                  message: 'Email Or Password is Wrong', status: false);
            }
          },
          builder: (context, state) {
            if (state is LoginSuccess) {
              return const MainScreen();
            } else {
              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16).r,
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const HeaderWidget(
                          title: 'LOG IN',
                        ),
                        30.verticalSpace,
                        LoginScreenBodyWidget(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              await authCubit.logIn(
                                  emailController.text.trim().toString(),
                                  passwordController.text.trim().toString());
                            } else {
                              UtilsConfig.showSnackBarMessage(
                                message: 'Enter valid Information',
                                status: false,
                              );
                            }
                          },
                          emailController: emailController,
                          passwordController: passwordController,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
