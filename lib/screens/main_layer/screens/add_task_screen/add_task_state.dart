part of 'add_task_cubit.dart';

@immutable
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

class AddTaskUploading extends AddTaskState {}

class AddTaskUploadSuccess extends AddTaskState {}

class AddTaskUploadFailed extends AddTaskState {}
