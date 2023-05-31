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

  List<Object?> get props => [user, isAdmin];
}

class IsLoadingState extends AuthenticationState {
  final bool isLoading;

  IsLoadingState({required this.isLoading});
}

class AuthFailure extends AuthenticationState {
  final String errorMessage;

  AuthFailure(this.errorMessage);
}

class SignUpInitial extends AuthenticationState {}

class SignUpProgress extends AuthenticationState {}

class SignUpSuccess extends AuthenticationState {
  final User user;

  SignUpSuccess(this.user);
}

class ChangePhoneNumber extends AuthenticationState {}

class ChangeCountryCode extends AuthenticationState {
  final countryCode;
  final String phone;

  ChangeCountryCode({
    required this.countryCode,
    required this.phone,
  });
}
