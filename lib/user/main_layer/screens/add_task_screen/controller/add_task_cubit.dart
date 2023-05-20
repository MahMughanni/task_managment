import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task_mangment/admin/controller/admin_cubit.dart';
import 'package:task_mangment/core/logic/firebase_controller.dart';
import 'package:task_mangment/core/routes/app_router.dart';
import 'package:task_mangment/core/routes/named_router.dart';
import 'package:task_mangment/model/user_model.dart';
import 'package:task_mangment/utils/utils_config.dart';

import 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  AddTaskCubit() : super(AddTaskInitial());
  FireBaseRepository repository = FireBaseRepository();

  List<File> imageFiles = [];
  bool isUploading = false;
  List tasksStatus = ['today', 'upcoming'];
  List projectStatus = ['working', 'completed'];
  AdminCubit adminCubit = AdminCubit();

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;
  late TextEditingController selectedDropdownValueController;
  late TextEditingController selectUserValueController;

  init() {
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    startTimeController = TextEditingController();
    endTimeController = TextEditingController();
    selectedDropdownValueController = TextEditingController();
    selectUserValueController = TextEditingController();
  }

  dispose() {
    titleController.dispose();
    descriptionController.dispose();
    startTimeController.dispose();
    selectUserValueController.dispose();
    endTimeController.dispose();
    selectedDropdownValueController.dispose();
  }

  String? selectedDropdownTaskValue;
  String? selectedDropdownProjectValue;
  String? selectUserDropdownValue;

  List<UserModel> users = []; // Define the users list

  Future<void> getAllUsers() async {
    try {
      final users = await repository.getAllUsers();
      emit(UsersLoadedState(users: users));
      this.users = users; // Update the users list
    } catch (e) {
      emit(UsersFailure(errorMessage: e.toString()));
    }
  }

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

      final dropdownValue = selectedDropdownTaskValue ?? '';

      // Clear the imageFiles list before adding new images
      imageFiles.clear();
      User? user = FirebaseAuth.instance.currentUser;

      // print(user.displayName);
      await repository.addTask(
        title: title,
        description: description,
        startTime: startTime,
        endTime: endTime,
        state: dropdownValue.toLowerCase(),
        imageFiles: imageFiles,
        userName: user?.displayName ?? '',
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
      emit(AddTaskFailure(errorMessage: e.toString()));
    } catch (e) {
      UtilsConfig.showSnackBarMessage(message: e.toString(), status: false);
      emit(AddTaskFailure(errorMessage: e.toString()));
    }
  }

  void createProject({
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

      final dropdownValueForProjects = selectedDropdownProjectValue ?? '';

      // Clear the imageFiles list before adding new images
      imageFiles.clear();
      await repository.createProject(
        title: title,
        description: description,
        startTime: startTime,
        endTime: endTime,
        state: dropdownValueForProjects.toLowerCase(),
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
        arguments: 'admin',
      );
    } on FirebaseException catch (e) {
      UtilsConfig.showFirebaseException(e);
      emit(AddTaskFailure(errorMessage: e.toString()));
    } catch (e) {
      UtilsConfig.showSnackBarMessage(message: e.toString(), status: false);
      emit(AddTaskFailure(errorMessage: e.toString()));
    }
  }

  void addTaskToUser({
    required String userId,
    required String userName,
    required String title,
    required String description,
    required String startTime,
    required String endTime,
  }) async {
    try {
      emit(AddTaskUploading());
      final dropdownValue = selectedDropdownTaskValue ?? '';
      await repository.addTaskForUser(
        userId: userId,
        title: title,
        description: description,
        startTime: startTime,
        endTime: endTime,
        state: dropdownValue.toLowerCase(),
        imageFiles: imageFiles,
        userName: userName, // Use the selected user's name
      );
      emit(AddTaskUploadSuccess());

      print('Added successfully');

      AppRouter.goTo(screenName: NamedRouter.mainScreen, arguments: 'admin');
      imageFiles.clear();
      // Fetch all tasks again to reflect the updated tasks list
      adminCubit.fetchAllTasks();
    } catch (error) {
      emit(AddTaskFailure(errorMessage: error.toString()));
    }
  }

  void uploadSuccess() {
    isUploading = !isUploading;
    emit(UploadSuccess(isSuccess: isUploading));
  }

  void updateValue(String value) {
    selectedDropdownTaskValue = value;
    final newState = AddTaskDropdownValueUpdated(selectedDropdownTaskValue!);
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

  Future<void> updateStatusDropdownValue(String value) async {
    selectedDropdownTaskValue = value;
    emit(AddTaskDropdownValueUpdated(selectedDropdownTaskValue!));
  }

  Future<void> updateUserDropdownValue(String value) async {
    selectUserDropdownValue = value;
    emit(AddTaskUserDropdownValueUpdated(selectUserDropdownValue!));
  }

  Future<void> updateAdminProjectDropdownValue(String value) async {
    selectedDropdownProjectValue = value;
    emit(AddProjectDropdownValueUpdated(selectedDropdownProjectValue!));
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