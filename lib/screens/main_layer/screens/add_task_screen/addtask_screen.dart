import 'dart:io';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task_mangment/logic/firebase_controller.dart';
import 'package:task_mangment/screens/main_layer/screens/add_task_screen/widgets/custom_drop_down.dart';
import 'package:task_mangment/screens/main_layer/screens/add_task_screen/widgets/create_task_body_widget.dart';
import 'package:task_mangment/utils/utils_config.dart';
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
  late TextEditingController _startTimeController;

  late TextEditingController _endTimeController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController();
    descriptionController = TextEditingController();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
  }

  List<File> _imageFiles = [];

  String _selectedDropdownValue = 'Today';

  // Future<void> _pickImages() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     type: FileType.image,
  //     allowMultiple: true,
  //   );
  //
  //   if (result != null) {
  //     setState(() {
  //       _imageFiles = result.paths.map((path) => File(path!)).toList();
  //     });
  //   }
  // }
  Future<void> _pickImages() async {
    await requestPermissions(); // Call the permission request function
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null) {
        setState(() {
          _imageFiles = result.paths.map((path) => File(path!)).toList();
        });
      }
    } else {
      // Handle denied or restricted status
    }
  }

  Future<void> requestPermissions() async {
    final statusStorage = await Permission.storage.request();
    final statusCamera = await Permission.camera.request();
    final statusMicrophone = await Permission.microphone.request();
    if (statusStorage.isDenied ||
        statusCamera.isDenied ||
        statusMicrophone.isDenied) {
      // Permission has been denied
      return;
    }
    if (statusStorage.isPermanentlyDenied ||
        statusCamera.isPermanentlyDenied ||
        statusMicrophone.isPermanentlyDenied) {
      // Permission has been permanently denied on iOS, navigate to app settings.
      openAppSettings();
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool _isUploading = false;

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
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      24.ph,
                      CustomTextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enter valid title';
                          }
                          return null;
                        },
                        labelText: 'Task Title',
                        hintText: '',
                        controller: titleController,
                      ),
                      16.ph,
                      CustomDropDown(
                        onChanged: (value) =>
                            setState(() => _selectedDropdownValue = value!),
                        dropDownValue: _selectedDropdownValue,
                        items: const [
                          DropdownMenuItem(
                              value: 'Upcoming', child: Text('Upcoming')),
                          DropdownMenuItem(
                              value: 'Today', child: Text('Today')),
                          DropdownMenuItem(
                              value: 'Completed', child: Text('Completed')),
                        ],
                      ),
                      16.ph,
                      16.ph,
                      CreateTaskBody(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enter valid text';
                          }
                          return null;
                        },
                        descriptionController: descriptionController,
                        onTap: _pickImages,
                        startTimeController: _startTimeController,
                        endTimeController: _endTimeController,
                      ),
                      if (_imageFiles.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _imageFiles
                              .map((imageFile) => Image.file(imageFile))
                              .toList(),
                        ),
                      32.ph,
                      Stack(
                        children: [
                          CustomButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isUploading = true;
                                });
                                try {
                                  await FireBaseController.addTask(
                                    title:
                                        titleController.text.toString().trim(),
                                    description: descriptionController.text
                                        .toString()
                                        .trim(),
                                    startTime: _startTimeController.text
                                        .toString()
                                        .trim(),
                                    endTime: _endTimeController.text
                                        .toString()
                                        .trim(),
                                    state: _selectedDropdownValue.toLowerCase(),
                                    imageFiles: _imageFiles,
                                  );
                                  UtilsConfig.showSnackBarMessage(
                                      message: 'Add Success', status: true);
                                  titleController.clear();
                                  descriptionController.clear();
                                  _startTimeController.clear();
                                  _endTimeController.clear();
                                  setState(() {
                                    _imageFiles.clear();
                                    _isUploading = false;
                                  });
                                } catch (e) {
                                  // print(e.toString());
                                  UtilsConfig.showSnackBarMessage(
                                      message: e.toString(), status: false);
                                  setState(() {
                                    _isUploading = false;
                                  });
                                }
                              }
                            },
                            title: 'Upload',
                            width: double.infinity,
                            height: 60,
                          ),
                          if (_isUploading)
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
