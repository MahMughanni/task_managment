part of 'setting_cubit.dart';

@immutable
abstract class SettingState {}

class SettingInitial extends SettingState {}

class EmployeeLoadingState extends SettingState {}

class EmployeeLoadedState extends SettingState {
  final List<DocumentSnapshot> users;

  EmployeeLoadedState({required this.users});
}

class EmployeeErrorState extends SettingState {
  final String error;

  EmployeeErrorState({required this.error});
}

