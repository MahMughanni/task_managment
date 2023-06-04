import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management/shared_widgets/custom_form_field.dart';

class CreateTaskBody extends StatelessWidget {
  const CreateTaskBody(
      {Key? key,
      required this.descriptionController,
      this.validator,
      required this.startTimeController,
      required this.endTimeController,
      required this.descriptionTitle})
      : super(key: key);
  final TextEditingController descriptionController;
  final String? Function(String?)? validator;
  final TextEditingController startTimeController;
  final String descriptionTitle;

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
                      focus: (_) =>
                          FocusScope.of(context).requestFocus(FocusNode()),
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
              const SizedBox(width: 6),
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
                      focus: (_) =>
                          FocusScope.of(context).requestFocus(FocusNode()),
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
          const SizedBox(height: 12),
          Text(descriptionTitle),
          const SizedBox(height: 8),
          CustomTextFormField(
            maxLine: 5,
            padding: EdgeInsetsDirectional.zero,
            focus: (_) => FocusScope.of(context).requestFocus(FocusNode()),
            validator: validator,
            controller: descriptionController,
            keyboardType: TextInputType.multiline,
            hintText: '',
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
