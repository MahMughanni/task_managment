import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/core/logic/base_cubit.dart';
import 'package:task_management/core/routes/app_router.dart';
import 'package:task_management/core/routes/named_router.dart';
import 'package:task_management/user/auth_layer/controller/authentication_cubit.dart';
import 'package:task_management/user/auth_layer/widgets/custom_rich_text.dart';
import 'package:task_management/shared_widgets/custom_button.dart';
import 'package:task_management/shared_widgets/custom_form_field.dart';
import 'package:task_management/utils/app_constants.dart';
import 'package:task_management/utils/extentions/string_validate_extention.dart';
import 'package:task_management/utils/utils_config.dart';

import 'widgets/header_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController userNameController;
  late TextEditingController phoneController;
  late AuthenticationCubit authCubit;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneController = TextEditingController();
    userNameController = TextEditingController();
    authCubit = BlocProvider.of<AuthenticationCubit>(context);
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
    return BlocConsumer<BaseCubit, BaseCubitState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          UtilsConfig.showSnackBarMessage(
            message: 'Thanks for signing up!',
            status: true,
          );
        }
        if (state is SignUpProgress) {
          UtilsConfig.showSnackBarMessage(message: 'loading', status: false);
        }
        if (state is AuthFailure) {
          UtilsConfig.showSnackBarMessage(
              message: 'Email Or Password is Wrong', status: false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ).r,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const HeaderWidget(
                        title: 'SIGN UP',
                      ),
                      24.verticalSpace,
                      CustomTextFormField(
                        focus: (_) => FocusScope.of(context).nearestScope,
                        controller: userNameController,
                        validator: (value) {
                          if (!value!.isValidName) {
                            return 'enter valid name';
                          }
                          return null;
                        },
                        labelText: 'Name',
                      ),
                      8.verticalSpace,
                      CustomTextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (!value!.isValidEmail) {
                            return 'enter valid email';
                          }
                          return null;
                        },
                        labelText: 'Email',
                        focus: (_) => FocusScope.of(context).nearestScope,
                      ),
                      8.verticalSpace,
                      CustomTextFormField(
                        suffixIconConstraints: BoxConstraints(
                          maxWidth: 100.r,
                        ),
                        focus: (_) => FocusScope.of(context).nearestScope,
                        controller: passwordController,
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
                          icon: Icon(
                            Icons.remove_red_eye_outlined,
                            size: 16.r,
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
                        isPassword:
                            BlocProvider.of<BaseCubit>(context).isPassword,
                        labelText: 'Password',
                      ),
                      8.verticalSpace,
                      CustomTextFormField(
                        focus: (_) => FocusScope.of(context).nearestScope,
                        controller: phoneController,
                        validator: (value) {
                          if (!value!.isValidNumber) {
                            return 'enter valid phone must start with +970 ';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        hintText: '+970',
                        labelText: 'phone',
                      ),
                      16.verticalSpace,
                      CustomButton(
                        title: 'SIGN UP',
                        width: double.infinity,
                        height: 42.h,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await authCubit.signUp(
                              email: emailController.text.trim().toString(),
                              password:
                                  passwordController.text.trim().toString(),
                              username:
                                  userNameController.text.trim().toString(),
                              phone: phoneController.text.trim().toString(),
                            );
                          } else {
                            UtilsConfig.showSnackBarMessage(
                                message: 'Enter valid Information',
                                status: false);
                          }
                        },
                      ),
                      CustomRichText(
                        title: 'Already have an account?',
                        subTitle: ' LOG IN',
                        subTextStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(
                                fontWeight: AppConstFontWeight.bold,
                                fontSize: 12.sp,
                                color: ColorConstManger.primaryColor),
                        tapGestureRecognizer: TapGestureRecognizer()
                          ..onTap = () {
                            BlocProvider.of<BaseCubit>(context)
                                .resetPasswordVisibility();
                            AppRouter.goToAndRemove(
                                routeName: NamedRouter.loginScreen);
                          },
                        padding: const EdgeInsets.all(20),
                        titleStyle:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  fontSize: 12.sp,
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
      },
    );
  }
}
