import 'package:flutter/material.dart';
import 'package:task_mangment/utils/app_constants.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    this.hintText,
    this.validator,
    this.isPassword,
    this.suffixIcon,
    this.initialValue,
    this.controller,
    this.labelText,
    this.maxLine,
    this.keyboardType,
    this.enabled,
    this.padding,
    this.contentPadding,
  }) : super(key: key);
  final String? hintText, initialValue, labelText;
  final String? Function(String?)? validator;
  final bool? isPassword;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final int? maxLine;
  final TextInputType? keyboardType;
  final bool? enabled;
  final EdgeInsetsDirectional? padding;
  final EdgeInsetsDirectional? contentPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsetsDirectional.all(8),
      child: TextFormField(
        enabled: enabled,
        maxLines: maxLine ?? 1,
        keyboardType: keyboardType,
        controller: controller,
        initialValue: initialValue,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: isPassword ?? false,
        validator: validator,
        decoration: InputDecoration(
          contentPadding: contentPadding ?? const EdgeInsetsDirectional.all(25),
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
      ),
    );
  }
}
