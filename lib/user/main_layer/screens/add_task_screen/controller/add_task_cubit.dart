import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task_mangment/core/routes/app_router.dart';
import 'package:task_mangment/core/routes/named_router.dart';
import 'package:task_mangment/logic/firebase_controller.dart';
import 'package:task_mangment/utils/utils_config.dart';

import 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  AddTaskCubit() : super(AddTaskInitial());

  List statusList = ['today', 'upcoming'];
  List<File> imageFiles = [];
  bool isUploading = false;

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;
  late TextEditingController selectedDropdownValueController;

  init() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    startTimeController = TextEditingController();
    endTimeController = TextEditingController();
    selectedDropdownValueController = TextEditingController();
  }

  dispose() {
    titleController.dispose();
    descriptionController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
  }

  String? selectedDropdownValue;

  void uploadTask({
    required String title,
    required String description,
    required String startTime,
    required String endTime,
  }) async {
    emit(AddTaskUploading());
    try {

      if (title.isEmpty ||
          description.isEmpty ||
          startTime.isEmpty ||
          endTime.isEmpty) {
        throw Exception("All fields are required.");
      }
      uploadSuccess();

      final dropdownValue = selectedDropdownValue ?? '';

      // Clear the imageFiles list before adding new images
      imageFiles.clear();

      await FireBaseRepository.addTask(
        title: title,
        description: description,
        startTime: startTime,
        endTime: endTime,
        state: dropdownValue.toLowerCase(),
        imageFiles: imageFiles,
      );
      UtilsConfig.showSnackBarMessage(message: 'Add Success', status: true);
      titleController.clear();
      descriptionController.clear();
      startTimeController.clear();
      selectedDropdownValueController.clear();
      endTimeController.clear();
      emit(AddTaskUploadSuccess());
      AppRouter.goToAndRemove(
        routeName: NamedRouter.mainScreen,
        arguments: 'user',
      );
    } on FirebaseException catch (e) {
      UtilsConfig.showFirebaseException(e);
      emit(AddTaskUploadFailed());
    } catch (e) {
      UtilsConfig.showSnackBarMessage(message: e.toString(), status: false);
      emit(AddTaskUploadFailed());
    }
  }

  void uploadSuccess() {
    isUploading = !isUploading;
    emit(UploadSuccess(isSuccess: isUploading));
  }

  void updateValue(String value) {
    selectedDropdownValue = value;
    final newState = AddTaskDropdownValueUpdated(selectedDropdownValue!);
    emit(newState);
  }

  Future<void> pickImages() async {
    await requestPermissions(); // Call the permission request function
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null) {
        imageFiles = result.paths.map((path) => File(path!)).toList();

        emit(AddTaskImageUpdated());
        // Check if all the required fields are filled
        if (titleController.text.isNotEmpty &&
            descriptionController.text.isNotEmpty &&
            startTimeController.text.isNotEmpty &&
            endTimeController.text.isNotEmpty) {
          // Call the uploadTask method with valid non-null values
          uploadTask(
            title: titleController.text,
            description: descriptionController.text,
            startTime: startTimeController.text,
            endTime: endTimeController.text,
          );
        } else {
          // Handle the case where any of the required fields is empty
          throw Exception("All fields are required.");
        }
      }
    } else {
      // Handle the case where storage permission is not granted
    }
  }

  void removeImage(File imageFile) {
    imageFiles.remove(imageFile);
    emit(RemoveTaskImageUpdated(imageFiles));
  }

  Future<void> updateSelectedDropdownValue(String value) async {
    selectedDropdownValue = value;
    emit(AddTaskDropdownValueUpdated(selectedDropdownValue!));
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
}
