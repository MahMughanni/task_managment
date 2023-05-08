import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task_mangment/core/routes/app_router.dart';
import 'package:task_mangment/core/routes/named_router.dart';
import 'package:task_mangment/logic/firebase_controller.dart';
import 'package:task_mangment/utils/utils_config.dart';

part 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  AddTaskCubit() : super(AddTaskInitial());

  List<File> imageFiles = [];
  bool isUploading = false;

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;

  init (){
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    startTimeController = TextEditingController();
    endTimeController = TextEditingController();
  }

  dispose (){
    titleController.dispose();
    descriptionController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
  }

  String selectedDropdownValue = 'Today';

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
      }
    } else {}
  }

  void removeImage(File imageFile) {
    imageFiles.remove(imageFile);
    emit(RemoveTaskImageUpdated(imageFiles));
  }


  void uploadTask({
    required String title,
    required String description,
    required String startTime,
    required String endTime,
  }) async {
    emit(AddTaskUploading());
    try {
      await FireBaseRepository.addTask(
        title: title,
        description: description,
        startTime: startTime,
        endTime: endTime,
        state: selectedDropdownValue.toLowerCase(),
        imageFiles: imageFiles,
      );
      UtilsConfig.showSnackBarMessage(message: 'Add Success', status: true);
      titleController.clear();
      descriptionController.clear();
      startTimeController.clear();
      endTimeController.clear();
      imageFiles.clear();
      emit(AddTaskUploadSuccess());
      AppRouter.goToAndRemove(routeName: NamedRouter.mainScreen);
    } catch (e) {
      print(e.toString());
      UtilsConfig.showSnackBarMessage(message: e.toString(), status: false);
      emit(AddTaskUploadFailed());
    }
  }


  Future<void> updateSelectedDropdownValue(String value) async {
    selectedDropdownValue = value;
    emit(AddTaskDropdownValueUpdated(selectedDropdownValue));
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
