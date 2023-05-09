

import 'dart:io';

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

class AddTaskImageUpdated extends AddTaskState {}

class RemoveTaskImageUpdated extends AddTaskState {
  final List<File> imageFiles;

  RemoveTaskImageUpdated(this.imageFiles);
}

class AddTaskLoading extends AddTaskState {}

class AddTaskSuccess extends AddTaskState {}


class AddTaskFailure extends AddTaskState {
  final String errorMessage;
  AddTaskFailure({required this.errorMessage});
}
class AddTaskUploading extends AddTaskState {}

class AddTaskUploadSuccess extends AddTaskState {}

class AddTaskUploadFailed extends AddTaskState {}
