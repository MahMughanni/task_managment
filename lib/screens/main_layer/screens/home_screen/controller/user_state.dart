import 'package:flutter/material.dart';
import 'package:task_mangment/model/task_model.dart';
import 'package:task_mangment/model/user_model.dart';

@immutable
abstract class HomeState {}

class UserInitial extends HomeState {}

class UserLoadingState extends HomeState {}

class UserLoadedState extends HomeState {
  final UserModel user;
  final List<TaskModel> tasks;
  UserLoadedState({required this.user, required this.tasks});
}

class UserUpdatingState extends HomeState {}

class UserErrorState extends HomeState {
  final String error;
  UserErrorState({required this.error});
}
