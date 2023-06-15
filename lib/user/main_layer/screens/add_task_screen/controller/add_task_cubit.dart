import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task_management/admin/controller/admin_cubit.dart';
import 'package:task_management/core/logic/firebase_controller.dart';
import 'package:task_management/core/routes/app_router.dart';
import 'package:task_management/core/routes/named_router.dart';
import 'package:task_management/model/user_model.dart';
import 'package:task_management/utils/utils_config.dart';
import 'package:uuid/uuid.dart';
import '../../notification_screen/controller/NotificationService.dart';
import 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
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
  String? selectedDropdownTaskValue;
  String? selectedDropdownProjectValue;
  String? selectUserDropdownValue;
  FirebaseMessaging? firebaseMessaging;

  List<UserModel> users = [];

  AddTaskCubit() : super(AddTaskInitial());

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

  clear() {
    titleController.clear();
    descriptionController.clear();
    startTimeController.clear();
    selectedDropdownValueController.clear();
    endTimeController.clear();
    imageFiles.clear();
  }

// add task for user by admin
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
        userName: 'Admin',
        assignedTo: userName,
      );

      emit(AddTaskUploadSuccess());

      final notificationsService = NotificationsService();
      // var token = await notificationsService.getUserDeviceToken(userId);

      // await  notificationsService.sendNotification(deviceToken: token!, title: 'New Task ', notificationBody: title);
      await notificationsService.sendTaskNotificationToUser(
        title: 'New Task',
        userId: userId,
        description: title,
        id: Uuid.NAMESPACE_OID,
      );

      clear();
      AppRouter.goToAndRemove(
          routeName: NamedRouter.mainScreen, arguments: 'admin');
      adminCubit.fetchAllTasks();
      close();
    } catch (error) {
      emit(AddTaskFailure(errorMessage: error.toString()));
    }
  }

//add task by user
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
      final dropdownValue = selectedDropdownTaskValue ?? '';
      User? user = FirebaseAuth.instance.currentUser;
      await repository.addTask(
        title: title,
        description: description,
        startTime: startTime,
        endTime: endTime,
        state: dropdownValue.toLowerCase(),
        imageFiles: imageFiles,
        userName: user?.displayName ?? '',
      );
      clear();
      UtilsConfig.showSnackBarMessage(message: 'Add Success', status: true);

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

// create project for admin
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

      await repository.createProject(
        title: title,
        description: description,
        startTime: startTime,
        endTime: endTime,
        state: dropdownValueForProjects.toLowerCase(),
        imageFiles: imageFiles,
      );

      UtilsConfig.showSnackBarMessage(message: 'Add Success', status: true);
      clear();
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

// get all user and show them in homeScreen
  Future<void> getAllUsers() async {
    try {
      final users = await repository.getAllUsers();
      emit(UsersLoadedState(users: users));
      this.users = users; // Update the users list
    } catch (e) {
      emit(UsersFailure(errorMessage: e.toString()));
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

// pickImages for both user and admin
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

// for select bottomSheet Value
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
