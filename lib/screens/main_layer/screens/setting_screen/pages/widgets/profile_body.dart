import 'package:flutter/material.dart';
import 'package:task_mangment/utils/extentions/padding_extention.dart';

import '../../../../../../shared_widgets/custom_circle_image.dart';
import '../../../../../../shared_widgets/custom_form_field.dart';

class ProfileBodyScreen extends StatelessWidget {
  const ProfileBodyScreen({
    Key? key,
    required this.initialData,
  }) : super(key: key);

  final List<String> initialData;

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
            const CustomCircleImage(
              url: '',
              width: 200,
              height: 200,
            ),
            Positioned(
              right: screenSize.height * 0.014,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                width: 50,
                height: 50,
              ),
            ),
          ],
        ),
        20.ph,
        CustomTextFormField(
            enabled: false, labelText: 'Email', initialValue: initialData[0]),
        16.ph,
        CustomTextFormField(
          initialValue: initialData[1],
          labelText: 'Password',
          isPassword: true,
          enabled: false,
        ),
        16.ph,
        CustomTextFormField(
          initialValue: initialData[2],
          enabled: false,
          labelText: 'Phone',
        ),
        16.ph,
        CustomTextFormField(
          initialValue: initialData[3],
          enabled: false,
          labelText: 'Position',
        ),
      ],
    );
  }
}
