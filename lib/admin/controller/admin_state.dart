part of 'admin_cubit.dart';

@immutable
abstract class AdminState {}

class AdminInitial extends AdminState {}

class AdminFailure extends AdminState {
  final String errorMessage;

  AdminFailure({required this.errorMessage});
}

class AdminLoadingState extends AdminState {}

class AdminTaskAddedState extends AdminState {}

class AdminTasksLoadedState extends AdminState {
  final UserModel? user;
  final List<TaskModel> tasks;

  AdminTasksLoadedState({required this.tasks, this.user});
}
