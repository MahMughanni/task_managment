part of 'authentication_cubit.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class LoginInitial extends AuthenticationState {}

class LoginInProgress extends AuthenticationState {}

class LoginSuccess extends AuthenticationState {
  final User user;
  final bool isAdmin;

  LoginSuccess(this.user, {this.isAdmin = false});

  @override
  List<Object?> get props => [user, isAdmin];
}

class AuthFailure extends AuthenticationState {
  final String errorMessage;

  AuthFailure(this.errorMessage);
}

// SignUp State

class SignUpInitial extends AuthenticationState {}

class SignUpProgress extends AuthenticationState {}

class SignUpSuccess extends AuthenticationState {
  final User user;

  SignUpSuccess(this.user);
}

