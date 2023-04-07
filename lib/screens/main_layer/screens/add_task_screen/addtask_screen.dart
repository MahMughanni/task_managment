import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:task_mangment/logic/firebase_controller.dart';
import 'package:task_mangment/screens/main_layer/screens/add_task_screen/widgets/CustomDropDown.dart';
import 'package:task_mangment/screens/main_layer/screens/add_task_screen/widgets/create_task_body_widget.dart';
import 'package:task_mangment/utils/UtilsConfig.dart';
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
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  List<File> _imageFiles = [];

  File? _imageFile;

  String _selectedDropdownValue = 'Today';

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _imageFiles = result.paths.map((path) => File(path!)).toList();
      });
    }
  }

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
                CustomTextFormField(
                  labelText: 'Task Title',
                  hintText: '',
                  controller: titleController,
                ),
                16.ph,
                CustomDropDown(
                    onChanged: (value) {
                      setState(() {
                        _selectedDropdownValue = value!;
                      });
                    },
                    dropDownValue: _selectedDropdownValue,
                    items: const [
                      DropdownMenuItem(
                          value: 'Upcoming', child: Text('Upcoming')),
                      DropdownMenuItem(value: 'Today', child: Text('Today')),
                      DropdownMenuItem(
                          value: 'Completed', child: Text('Completed')),
                    ]),
                16.ph,
                CreateTaskBody(
                  descriptionController: descriptionController,
                  onTap: _pickImages,
                ),
                if (_imageFiles.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _imageFiles
                        .map((imageFile) => Image.file(imageFile))
                        .toList(),
                  ),
                ],
                32.ph,
                CustomButton(
                  onPressed: () async {
                    try {
                      await FireBaseController.addTask(
                        title: titleController.text.toString().trim(),
                        description:
                            descriptionController.text.toString().trim(),
                        startTime: DateTime.now().toString(),
                        endTime: DateTime.now().toString(),
                        state: _selectedDropdownValue.toLowerCase(),
                        imageFiles: _imageFiles,
                      );

                      UtilsConfig.showSnackBarMessage(
                          message: 'Add Success', status: true);
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  title: 'Upload',
                  width: double.infinity,
                  height: 60,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Future<void> _pickImage() async {
//   final picker = ImagePicker();
//   final pickedImage = await picker.pickImage(source: ImageSource.gallery);
//
//   if (pickedImage != null) {
//     setState(() {
//       _imageFile = File(pickedImage.path);
//     });
//   }
// }
