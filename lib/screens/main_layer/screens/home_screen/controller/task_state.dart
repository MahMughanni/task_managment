import 'package:flutter/material.dart';
import 'package:task_mangment/model/task_model.dart';
import 'package:task_mangment/model/user_model.dart';

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

class UserErrorState extends TaskState {
  final String error;

  UserErrorState({required this.error});
}

class UserConnectedState extends TaskState {}

class UserReconnectedState extends TaskState {}

class UserDisconnectedState extends TaskState {}
