part of 'base_cubit.dart';

@immutable
abstract class BaseCubitState {}

class BaseCubitInitial extends BaseCubitState {}

class BasePasswordVisibilityChanged extends BaseCubitState {
  final bool isPassword;

  BasePasswordVisibilityChanged({required this.isPassword});
}

class BaseCubitErrorState extends BaseCubitState {
  final String error;

  BaseCubitErrorState({required this.error});
}