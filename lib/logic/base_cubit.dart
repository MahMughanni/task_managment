import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'base_state.dart';

class BaseCubit extends Cubit<BaseCubitState> {
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
