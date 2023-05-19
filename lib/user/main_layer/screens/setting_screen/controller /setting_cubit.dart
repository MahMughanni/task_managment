import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:task_mangment/core/logic/firebase_controller.dart';
import 'package:task_mangment/model/user_model.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  FireBaseRepository repository = FireBaseRepository();

  SettingCubit() : super(SettingInitial());

  Future<void> getAllUsers() async {
    try {
      final users = await repository.getAllUsers();
      emit(EmployeeLoadedState(users: users));
    } catch (e) {
      emit(EmployeeErrorState(error: e.toString()));
    }
  }
}
