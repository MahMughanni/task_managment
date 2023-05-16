import 'dart:io';

import 'package:flutter/material.dart';
import 'package:task_mangment/utils/extentions/padding_extention.dart';
import 'package:task_mangment/utils/extentions/string_validate_extention.dart';

import '../../../../../../shared_widgets/custom_circle_image.dart';
import '../../../../../../shared_widgets/custom_form_field.dart';

class ProfileBodyScreen extends StatelessWidget {
  const ProfileBodyScreen({
    Key? key,
    required this.initialData,
    this.isEnabled = false,
    required this.screen,
    this.userNameController,
    this.passwordController,
    this.phoneController,
    this.positionController,
    this.onTap,
    this.newImage,
    this.imageUrl,
  }) : super(key: key);

  final List<String> initialData;
  final bool? isEnabled;
  final String screen;
  final TextEditingController? userNameController;
  final TextEditingController? passwordController;
  final TextEditingController? phoneController;
  final TextEditingController? positionController;
  final Function()? onTap;
  final File? newImage;

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            CustomCircleImage(
              image: imageUrl ?? newImage,
              width: 200,
              height: 200,
            ),
            Positioned(
              right: screenSize.height * 0.014,
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 0),
                        blurRadius: 10,
                        spreadRadius: 1,
                        color: Colors.grey)
                  ],
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                width: 50,
                height: 50,
                child: InkWell(
                  onTap: onTap,
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        20.ph,
        Visibility(
          visible: screen == 'profile' ? true : false,
          child: CustomTextFormField(
            controller: userNameController,
            enabled: false,
            labelText: 'Email',
            initialValue: screen == 'profile' ? initialData[1] : '',
          ),
        ),
        16.ph,
        Visibility(
          visible: screen == 'profile' ? true : false,
          child: CustomTextFormField(
            initialValue: screen == 'profile' ? initialData[2] : '',
            labelText: 'Password',
            isPassword: true,
            enabled: false,
          ),
        ),
        16.ph,
        CustomTextFormField(
          validator: (value) {
            if (!value!.isValidName) {
              return 'enter valid email ';
            }
            return null;
          },
          controller: userNameController,
          enabled: isEnabled,
          labelText: 'User Name',
          initialValue: screen == 'profile' ? initialData[0] : null,
        ),
        16.ph,
        CustomTextFormField(
          validator: (value) {
            if (!value!.isValidNumber) {
              return 'enter valid phone must start with +970 ';
            }
            return null;
          },
          controller: phoneController,
          initialValue: screen == 'profile' ? initialData[3] : null,
          enabled: isEnabled,
          labelText: 'Phone',
        ),
        16.ph,
        CustomTextFormField(
          validator: (value) {
            if (!value!.isValidName) {
              return 'enter valid name';
            }
            return null;
          },
          controller: positionController,
          initialValue: screen == 'profile' ? initialData[4] : null,
          enabled: isEnabled,
          labelText: 'Position',
        ),
      ],
    );
  }
}
