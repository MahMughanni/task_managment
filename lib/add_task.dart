import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

class TaskMang {
  Future<void> addTask(BuildContext context) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? startTime;
    DateTime? endTime;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  startTime = await showDateTimePicker(
                    context: context,
                  );
                },
                child: const Text('Select Start Time'),
              ),
              ElevatedButton(
                onPressed: () async {
                  endTime = await showDateTimePicker(
                    context: context,
                  );
                },
                child: const Text('Select End Time'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          // TextButton(
          //   onPressed: () async {
          //     final title = titleController.text;
          //     final description = descriptionController.text;
          //     if (title.isNotEmpty &&
          //         description.isNotEmpty &&
          //         startTime != null &&
          //         endTime != null) {
          //       await addTask(title, description, startTime!, endTime!);
          //       Navigator.pop(context);
          //     }
          //   },
          //   child: const Text('Add'),
          // ),
        ],
      ),
    );
  }

  Future<DateTime?> showDateTimePicker({required BuildContext context}) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    if (pickedDate == null) return null;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );
    if (pickedTime == null) return null;

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }
}
