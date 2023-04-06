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
    this.labelText,
    this.maxLine,
    this.keyboardType,
    this.enabled,
  }) : super(key: key);
  final String? hintText, initialValue, labelText;
  final String? Function(String?)? validator;
  final bool? isPassword;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final int? maxLine;
  final TextInputType? keyboardType;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      maxLines: maxLine ?? 1,
      keyboardType: keyboardType,
      controller: controller,
      initialValue: initialValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: isPassword ?? false,
      validator: validator,
      decoration: InputDecoration(
        label: Text(labelText ?? ''),
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
