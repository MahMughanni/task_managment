import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_mangment/utils/extentions/padding_extention.dart';

import '../../../../../shared_widgets/custom_form_field.dart';

class CreateTaskBody extends StatelessWidget {
  const CreateTaskBody(
      {Key? key,
      required this.onTap,
      required this.descriptionController,
      this.validator,
      required this.startTimeController,
      required this.endTimeController})
      : super(key: key);
  final Function()? onTap;
  final TextEditingController descriptionController;
  final String? Function(String?)? validator;
  final TextEditingController startTimeController;

  final TextEditingController endTimeController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 10),
                    );
                    if (picked != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        startTimeController.text =
                            DateFormat.yMMMEd().add_jm().format(
                                  DateTime(picked.year, picked.month,
                                      picked.day, time.hour, time.minute),
                                );
                      }
                    }
                  },
                  child: AbsorbPointer(
                    child: CustomTextFormField(
                      suffixIcon: const Icon(Icons.calendar_today),
                      labelText: 'Start',
                      hintText: '5.apr 10:00pm',
                      controller: startTimeController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a start time';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              16.pw,
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 10),
                    );
                    if (picked != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        endTimeController.text =
                            DateFormat.yMMMEd().add_jm().format(
                                  DateTime(picked.year, picked.month,
                                      picked.day, time.hour, time.minute),
                                );
                      }
                    }
                  },
                  child: AbsorbPointer(
                    child: CustomTextFormField(
                      suffixIcon: const Icon(Icons.calendar_today),
                      labelText: 'End',
                      hintText: '5.apr 10:00pm',
                      controller: endTimeController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an end time';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          16.ph,
          const Text('Task Description'),
          8.ph,
          CustomTextFormField(
            padding: const EdgeInsetsDirectional.all(0),
            validator: validator,
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
      ),
    );
  }
}
