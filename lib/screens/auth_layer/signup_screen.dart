import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_mangment/core/routes/app_router.dart';
import 'package:task_mangment/logic/firebase_controller.dart';
import 'package:task_mangment/screens/auth_layer/widgets/custom_rich_text.dart';
import 'package:task_mangment/utils/utils_config.dart';
import 'package:task_mangment/utils/extentions/padding_extention.dart';
import 'package:task_mangment/utils/extentions/string_validate_extention.dart';

import '../../core/routes/named_router.dart';
import '../../shared_widgets/custom_button.dart';
import '../../shared_widgets/custom_form_field.dart';
import '../../utils/app_constants.dart';
import 'widgets/header_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPassword = true;

  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController userNameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneController = TextEditingController();
    userNameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 34,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const HeaderWidget(
                    title: 'SIGN UP',
                  ),
                  34.ph,
                  CustomTextFormField(
                    controller: userNameController,
                    validator: (value) {
                      if (!value!.isValidName) {
                        return 'enter valid name';
                      }
                      return null;
                    },
                    hintText: 'Name',
                  ),
                  16.ph,
                  CustomTextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (!value!.isValidEmail) {
                        return 'enter valid email';
                      }
                      return null;
                    },
                    hintText: 'Email',
                  ),
                  16.ph,
                  CustomTextFormField(
                    controller: passwordController,
                    suffixIcon: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      disabledColor: Colors.transparent,
                      color: _isPassword ? Colors.grey : Colors.blue,
                      onPressed: () {
                        setState(() {
                          _isPassword = !_isPassword;
                        });
                      },
                      icon: const Icon(
                        Icons.remove_red_eye_outlined,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'enter valid password';
                      }
                      if (value.trim().length < 6) {
                        return 'minimum length 6 ';
                      }
                      if (!value.isContainSmallLetter(value)) {
                        return 'Should contain at least a small letter';
                      }
                      if (!value.isContainCapitalLetter(value)) {
                        return 'Should contain at least a capital letter';
                      }
                      if (!value.isContainSpecialCharacter(value)) {
                        return 'Should contain at least a Special Character';
                      }
                      if (!value.isContainNumber(value)) {
                        return 'Should contain at least a Number';
                      }
                      return null;
                    },
                    isPassword: _isPassword,
                    hintText: 'Password',
                  ),
                  24.ph,
                  CustomTextFormField(
                    controller: phoneController,
                    validator: (value) {
                      if (!value!.isValidNumber) {
                        return 'enter valid phone must start with +970 ';
                      }
                      return null;
                    },
                    hintText: '+970',
                  ),
                  16.ph,
                  CustomButton(
                    title: 'SIGN UP',
                    width: double.infinity,
                    height: 52,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        FireBaseController.createUserAccount(
                          emailController.text.trim().toString(),
                          passwordController.text.trim().toString(),
                          userNameController.text.trim().toString(),
                          phoneController.text.trim().toString(),
                        );
                        AppRouter.goToAndRemove(
                            screenName: NamedRouter.loginScreen);

                        UtilsConfig.showSnackBarMessage(
                            message: 'Thanks for signing up!.', status: true);
                      } else {
                        UtilsConfig.showSnackBarMessage(
                            message: 'Enter valid Information', status: false);
                      }
                    },
                  ),
                  CustomRichText(
                    title: 'Don\'t have an account yet ?',
                    subTitle: ' LOG IN',
                    subTextStyle: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(
                            fontWeight: AppConstFontWeight.bold,
                            color: ColorConstManger.primaryColor),
                    tapGestureRecognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pop(context);
                      },
                    padding: const EdgeInsets.all(20),
                    titleStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.black.withOpacity(.7),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
