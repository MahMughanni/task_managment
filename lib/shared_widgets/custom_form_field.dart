import 'package:flutter/material.dart';
import 'package:task_mangment/utils/app_constants.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required this.hintText,
    this.validator,
    this.isPassword,
    this.suffixIcon,
    this.initialValue,
    this.controller,
  }) : super(key: key);
  final String? hintText, initialValue;
  final String? Function(String?)? validator;
  final bool? isPassword;
  final Widget? suffixIcon;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: isPassword ?? false,
      validator: validator,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        fillColor: ColorConstManger.formFieldFiledColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(9),
        ),
        hintText: hintText,
      ),
    );
  }
}
