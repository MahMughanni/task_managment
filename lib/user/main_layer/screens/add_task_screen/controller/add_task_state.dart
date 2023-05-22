import 'dart:io';

import 'package:task_management/model/user_model.dart';

abstract class AddTaskState {}

class AddTaskInitial extends AddTaskState {}

class AddTaskImagesUpdated extends AddTaskState {
  final List<File> imageFiles;

  AddTaskImagesUpdated(this.imageFiles);
}

class AddTaskDropdownValueUpdated extends AddTaskState {
  final String selectedValue;

  AddTaskDropdownValueUpdated(this.selectedValue);
}

class AddTaskUserDropdownValueUpdated extends AddTaskState {
  final String selectedValue;

  AddTaskUserDropdownValueUpdated(this.selectedValue);
}
class AddProjectDropdownValueUpdated extends AddTaskState {
  final String selectedValue;

  AddProjectDropdownValueUpdated(this.selectedValue);
}

class AddTaskImageUpdated extends AddTaskState {}

class RemoveTaskImageUpdated extends AddTaskState {
  final List<File> imageFiles;

  RemoveTaskImageUpdated(this.imageFiles);
}

class AddTaskLoading extends AddTaskState {}

class AddTaskSuccess extends AddTaskState {}

class UploadSuccess extends AddTaskState {
  final bool isSuccess;

  UploadSuccess({required this.isSuccess});
}

class AddTaskFailure extends AddTaskState {
  final String errorMessage;

  AddTaskFailure({required this.errorMessage});
}

class AddTaskUploading extends AddTaskState {}

class AddTaskUploadSuccess extends AddTaskState {}

class UsersLoadedState extends AddTaskState {
  final List<UserModel> users;

  UsersLoadedState({required this.users});
}

class UsersFailure extends AddTaskState {
  final String errorMessage;

  UsersFailure({required this.errorMessage});
}
