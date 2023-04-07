import 'package:flutter/material.dart';
import 'package:task_mangment/utils/extentions/padding_extention.dart';

import '../../../../../shared_widgets/custom_form_field.dart';
import '../../../../../utils/app_constants.dart';

class CreateTaskBody extends StatelessWidget {
  const CreateTaskBody(
      {Key? key, required this.onTap, required this.descriptionController})
      : super(key: key);
  final Function()? onTap;
  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Start',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: ColorConstManger.primaryColor,
                        ),
                  ),
                  const CustomTextFormField(
                    suffixIcon: Icon(Icons.calendar_month),
                    labelText: '',
                    hintText: '5.apr 10:00pm',
                  ),
                ],
              ),
            ),
            16.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'End',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: ColorConstManger.primaryColor,
                        ),
                  ),
                  const CustomTextFormField(
                    suffixIcon: Icon(Icons.calendar_month),
                    labelText: '',
                    hintText: '5.apr 10:00pm',
                  ),
                ],
              ),
            ),
          ],
        ),
        16.ph,
        const Text('Task Description'),
        8.ph,
        CustomTextFormField(
          controller: descriptionController,
          maxLine: 10,
          keyboardType: TextInputType.multiline,
          hintText: '',
        ),
        20.ph,
        GestureDetector(
          onTap: onTap,
          child: const CustomTextFormField(
            suffixIcon: Icon(Icons.link_sharp),
            enabled: false,
            hintText: '',
            labelText: 'Attach files',
          ),
        ),
      ],
    );
  }
}
