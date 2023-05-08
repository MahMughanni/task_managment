import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'base_state.dart';

class BaseCubit extends Cubit<BaseCubitState> {

  final user = FirebaseAuth.instance.currentUser;
  final userAUTH = FirebaseAuth.instance;

  BaseCubit() : super(BaseCubitInitial());
  bool isPassword = true;

  void showPassword() {
    isPassword = !isPassword;
    emit(BasePasswordVisibilityChanged(isPassword: isPassword));
  }

  void resetPasswordVisibility() {
    isPassword = true;
    emit(BasePasswordVisibilityChanged(isPassword: isPassword));
  }
}
