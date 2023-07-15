import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_management/model/task_model.dart';
import 'package:task_management/model/user_model.dart';

@immutable
abstract class TaskState {}

class UserInitial extends TaskState {}

class UserLoadingState extends TaskState {}

class UserLoadedState extends TaskState {
  final UserModel user;
  final List<TaskModel> tasks;

  UserLoadedState({required this.user, required this.tasks});
}

class UserUpdatingState extends TaskState {}

class UserConnectedState extends TaskState {}

class ChangeTaskState extends TaskState {
  final bool isTaskCompleted;

  ChangeTaskState({required this.isTaskCompleted});
}

class UserReconnectedState extends TaskState {}

class UserDisconnectedState extends TaskState {}

class TaskLoadingState extends TaskState {}

class TaskLoadedState extends TaskState {
  final User user;
  final List<TaskModel> tasks;

  TaskLoadedState({required this.user, required this.tasks});
}

class Failure extends TaskState {
  final String errorMessage;

  Failure({required this.errorMessage});
}
