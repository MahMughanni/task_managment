import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_mangment/core/routes/app_router.dart';
import 'package:task_mangment/core/routes/named_router.dart';
import 'package:task_mangment/logic/base_cubit.dart';
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
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BaseCubit, BaseCubitState>(
      listener: (context, state) {},
      builder: (context, state) {
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
              labelText: 'Email',
            ),
            8.verticalSpace,
            CustomTextFormField(
              controller: widget.passwordController,
              suffixIcon: IconButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                disabledColor: Colors.transparent,
                color: BlocProvider.of<BaseCubit>(context).isPassword
                    ? Colors.grey
                    : Colors.blue,
                onPressed: () {
                  BlocProvider.of<BaseCubit>(context).showPassword();
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
              isPassword: BlocProvider.of<BaseCubit>(context).isPassword,
              labelText: 'Password',
            ),
            8.verticalSpace,
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'forget password ?',
                  style: TextStyle(
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
            8.verticalSpace,
            CustomButton(
              title: 'LOG IN',
              width: double.infinity,
              height: 42.h,
              onPressed: widget.onPressed,
            ),
            CustomRichText(
              title: 'Don\'t have an account yet ?',
              subTitle: ' SIGN UP',
              subTextStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: AppConstFontWeight.bold,
                  fontSize: 12.sp,
                  color: ColorConstManger.primaryColor),
              tapGestureRecognizer: TapGestureRecognizer()
                ..onTap = () {
                  BlocProvider.of<BaseCubit>(context).resetPasswordVisibility();
                  AppRouter.goToAndRemove(screenName: NamedRouter.signUpScreen);
                },
              padding: const EdgeInsets.all(20),
              titleStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 12.sp,
                    color: Colors.black.withOpacity(.7),
                  ),
            ),
          ],
        );
      },
    );
  }
}
