import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:task_mangment/logic/firebase_controller.dart';
import 'package:task_mangment/screens/main_layer/screens/add_task_screen/widgets/CustomDropDown.dart';
import 'package:task_mangment/utils/app_constants.dart';
import 'package:task_mangment/utils/extentions/padding_extention.dart';

import '../../../../shared_widgets/custom_button.dart';
import '../../../../shared_widgets/custom_form_field.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white54,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          'Create Task',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomTextFormField(
                  labelText: 'Task Title',
                  hintText: '',
                ),
                16.ph,
                CustomDropDown(
                    onChanged: (value) {},
                    dropDownValue: 'Today',
                    items: const ['Upcoming', 'Today', 'Completed']),
                16.ph,
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
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
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
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
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
                const CustomTextFormField(
                  maxLine: 10,
                  keyboardType: TextInputType.multiline,
                  hintText: '',
                ),
                20.ph,
                GestureDetector(
                  onTap: _pickImage,
                  child: const CustomTextFormField(
                    suffixIcon: Icon(Icons.link_sharp),
                    enabled: false,
                    hintText: '',
                    labelText: 'Attach file',
                  ),
                ),
                32.ph,
                CustomButton(
                  onPressed: () async {
                    try {
                      await FireBaseController.addTask(
                        title: 'Task title',
                        description: 'Task description',
                        startTime: DateTime.now(),
                        endTime: DateTime.now().add(const Duration(hours: 1)),
                        state: 'incomplete',
                        imageFile: _imageFile!,
                      );
                      // show a success message to the user
                    } catch (e) {
                      // handle the error and show an error message to the user
                    }
                  },
                  title: 'Upload',
                  width: double.infinity,
                  height: 60,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }
}
