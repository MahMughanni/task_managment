import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> deleteTask({required String userId, required String id}) async {
    try {
      final taskDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .doc(id);
      await taskDoc.delete();
    } catch (e) {
      emit(BaseCubitErrorState(error: e.toString()));
    }
  }
}
