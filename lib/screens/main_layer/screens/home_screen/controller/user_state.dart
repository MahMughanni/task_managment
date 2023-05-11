import 'package:flutter/material.dart';
import 'package:task_mangment/model/task_model.dart';
import 'package:task_mangment/model/user_model.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoadingState extends UserState {}

class UserLoadedState extends UserState {
  final UserModel user;
  final List<TaskModel> tasks;

  UserLoadedState({required this.user, required this.tasks});
}

class UserUpdatingState extends UserState {}

class UserErrorState extends UserState {
  final String error;

  UserErrorState({required this.error});
}

class UserConnectedState extends UserState {}

class UserReconnectedState extends UserState {}

class UserDisconnectedState extends UserState {}
