import 'package:flutter/material.dart';
import 'package:task_management/utils/app_constants.dart';


class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.dropDownValue,
    required this.items,
    this.onChanged,
  });

  final String dropDownValue;
  final List<DropdownMenuItem> items;
  final Function(dynamic)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade200,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: Color(ColorConstManger.borderContainer),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: Color(ColorConstManger.borderContainer),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: Color(ColorConstManger.borderContainer),
          ),
        ),
      ),
      borderRadius: BorderRadius.circular(7),
      style: const TextStyle(color: Colors.black, fontSize: 16),
      value: dropDownValue,
      icon: const Icon(Icons.keyboard_arrow_down),
      items: items,

      // logic here
      onChanged: onChanged,
    );
  }
}
