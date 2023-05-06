import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    this.focus,
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
  final void Function(String)? focus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??  REdgeInsets.all(8),
      child: TextFormField(
        enabled: enabled,
        maxLines: maxLine ?? 1,
        keyboardType: keyboardType,
        controller: controller,
        initialValue: initialValue,
        onFieldSubmitted: focus ?? (_) => FocusScope.of(context).nearestScope,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: isPassword ?? false,
        validator: validator,
        style: TextStyle(fontSize: 12.sp),
        decoration: InputDecoration(
          hintStyle: TextStyle(fontSize: 12.sp),
          contentPadding: contentPadding ??  REdgeInsets.all(15),
          label: Text(labelText ?? ''),
          suffixIcon: suffixIcon,
          fillColor: ColorConstManger.formFieldFiledColor,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(9).w,
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
