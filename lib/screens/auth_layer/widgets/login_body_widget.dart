import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_mangment/utils/extentions/padding_extention.dart';
import 'package:task_mangment/utils/extentions/string_validate_extention.dart';

import '../../../shared_widgets/custom_button.dart';
import '../../../shared_widgets/custom_form_field.dart';
import '../../../utils/app_constants.dart';
import '../signup_screen.dart';
import 'custom_rich_text.dart';

class LoginScreenBodyWidget extends StatefulWidget {
  const LoginScreenBodyWidget({
    Key? key,
    required this.onPressed,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);
  final Function()? onPressed;

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<LoginScreenBodyWidget> createState() => _LoginScreenBodyWidgetState();
}

class _LoginScreenBodyWidgetState extends State<LoginScreenBodyWidget> {
  bool _isPassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          controller: widget.emailController,
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
          controller: widget.passwordController,
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
          onPressed: widget.onPressed,
        ),
        CustomRichText(
          title: 'Don\'t have an account yet ?',
          subTitle: ' SIGN UP',
          subTextStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
    );
  }
}
