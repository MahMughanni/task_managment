import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_mangment/screens/auth_layer/signup_screen.dart';
import 'package:task_mangment/screens/auth_layer/widgets/custom_rich_text.dart';
import 'package:task_mangment/screens/auth_layer/widgets/header_widget.dart';
import 'package:task_mangment/utils/app_constants.dart';
import 'package:task_mangment/utils/extentions/padding_extention.dart';
import 'package:task_mangment/utils/extentions/string_validate_extention.dart';
import '../../shared_widgets/custom_button.dart';
import '../../shared_widgets/custom_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPassword = true;

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
                    title: 'LOG IN',
                  ),
                  34.ph,
                  CustomTextFormField(
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
                  8.ph,
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('forget password ?'),
                    ),
                  ),
                  24.ph,
                  CustomButton(
                    title: 'LOG IN',
                    width: double.infinity,
                    height: 52,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Success'),
                          ),
                        );
                      }
                    },
                  ),
                  CustomRichText(
                    title: 'Don\'t have an account yet ?',
                    subTitle: ' SIGN UP',
                    subTextStyle: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(
                            fontWeight: AppConstFontWeight.bold,
                            color: ColorConstManger.primaryColor!),
                    tapGestureRecognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return const SignUpScreen();
                            },
                          ),
                        );
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
