import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_management/utils/app_constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      this.onChanged,
      this.controller,
      this.haveTitle = true,
      this.haveBorderLeft = false,
      this.haveBorderRight = false,
      required this.hintText,
      required this.focuse,
      this.validator,
      this.maxLines = 1,
      this.enable = true,
      this.obscureText = false,
      this.haveIcon = false,
      this.keyboardType,
      this.prefixIcon,
      this.title,
      this.focusNode,
      this.onTapIcon,
      this.inputFormatters,
      this.fillColor = ColorConstManger.white,
      this.onEditingComplete,
      this.textInputAction = TextInputAction.next,
      this.suffixIcon,
      this.suffixIconConstraints});

  final Color? fillColor;
  final void Function()? onEditingComplete;
  final bool haveBorderLeft;
  final bool haveBorderRight;
  final bool haveTitle;
  final bool haveIcon;
  final void Function()? onTapIcon;
  final int maxLines;
  final String? title;
  final String hintText;
  final bool obscureText;
  final bool enable;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final Function(String?)? onChanged;
  final void Function(String) focuse;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final BoxConstraints? suffixIconConstraints;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            haveTitle
                ? Text(
                    title!,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorConstManger.formFieldFiledColor,
                    ),
                  )
                : const SizedBox(),
            haveIcon
                ? InkWell(
                    onTap: onTapIcon,
                    child: const Icon(
                      Icons.cancel,
                      color: ColorConstManger.black,
                    ))
                : const SizedBox(),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          enabled: enable,
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          maxLines: maxLines,
          inputFormatters: inputFormatters ?? [],
          autovalidateMode: AutovalidateMode.disabled,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          keyboardType: keyboardType ?? TextInputType.text,
          onFieldSubmitted: focuse,
          controller: controller,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            suffixIconConstraints: suffixIconConstraints,
            isDense: true,
            hintText: hintText,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            filled: true,
            errorStyle: const TextStyle(height: 0, color: Colors.red),
            hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: ColorConstManger.black.withOpacity(0.4),
                fontSize: 14.sp),
            fillColor: fillColor,
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(!haveBorderLeft ? 7 : 0),
                topRight: Radius.circular(!haveBorderRight ? 7 : 0),
                bottomRight: Radius.circular(!haveBorderRight ? 7 : 00.0),
                bottomLeft: Radius.circular(!haveBorderLeft ? 7 : 00.0),
              ),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(!haveBorderLeft ? 7 : 0),
                topRight: Radius.circular(!haveBorderRight ? 7 : 0),
                bottomRight: Radius.circular(!haveBorderRight ? 7 : 00.0),
                bottomLeft: Radius.circular(!haveBorderLeft ? 7 : 00.0),
              ),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(!haveBorderLeft ? 7 : 0),
                topRight: Radius.circular(!haveBorderRight ? 7 : 0),
                bottomRight: Radius.circular(!haveBorderRight ? 7 : 00.0),
                bottomLeft: Radius.circular(!haveBorderLeft ? 7 : 00.0),
              ),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(!haveBorderLeft ? 7 : 0),
                topRight: Radius.circular(!haveBorderRight ? 7 : 0),
                bottomRight: Radius.circular(!haveBorderRight ? 7 : 00.0),
                bottomLeft: Radius.circular(!haveBorderLeft ? 7 : 00.0),
              ),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedBorder: InputBorder.none,
          ),
          style: TextStyle(
            fontSize: 16,
            color: enable ? ColorConstManger.black : ColorConstManger.lightGrey,
          ),
        ),
      ],
    );
  }
}
