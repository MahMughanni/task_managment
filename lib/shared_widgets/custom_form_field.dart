import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/utils/app_constants.dart';

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
    this.fontSize,
    this.padding,
    this.contentPadding,
    this.focus,
    this.prefixIcon,
    this.suffixIconConstraints,
    this.hintStyle,
    this.titleStyle,
    this.textInputAction,
    this.onChanged,
  }) : super(key: key);
  final String? hintText, initialValue, labelText;
  final String? Function(String?)? validator;
  final bool? isPassword;
  final Widget? suffixIcon;
  final double? fontSize;

  final Widget? prefixIcon;
  final TextEditingController? controller;
  final int? maxLine;
  final TextInputType? keyboardType;
  final bool? enabled;
  final EdgeInsetsDirectional? padding;
  final EdgeInsetsDirectional? contentPadding;
  final void Function(String)? focus;
  final BoxConstraints? suffixIconConstraints;
  final TextStyle? hintStyle;
  final TextStyle? titleStyle;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? REdgeInsets.all(8),
      child: TextFormField(
        enabled: enabled,
        onChanged: onChanged,
        maxLines: maxLine ?? 1,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        controller: controller,
        initialValue: initialValue,
        onFieldSubmitted: focus ?? (_) => FocusScope.of(context).nearestScope,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: isPassword ?? false,
        validator: validator,
        style: titleStyle ?? Theme.of(context).textTheme.bodySmall,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIconConstraints: suffixIconConstraints,
          hintStyle: hintStyle ?? Theme.of(context).textTheme.bodySmall,
          contentPadding: contentPadding ?? REdgeInsets.all(15),
          label: Text(labelText ?? ''),
          labelStyle: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.grey, fontSize: fontSize ?? 13.sp),
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
