import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:task_mangment/model/task_model.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit() : super(AdminInitial());

  StreamSubscription<QuerySnapshot>? tasksSubscription;

  Future<void> fetchAllTasks() async {
    try {
      emit(AdminLoadingState());

      final usersCollection = FirebaseFirestore.instance.collection('users');
      final snapshots = usersCollection.snapshots();

      tasksSubscription = snapshots.listen((querySnapshot) {
        final tasks = <TaskModel>[];

        for (var userDoc in querySnapshot.docs) {
          final tasksCollection = userDoc.reference.collection('tasks');
          tasksCollection
              .orderBy('createdAt', descending: true)
              .snapshots()
              .listen((taskSnapshot) {
            for (var taskDoc in taskSnapshot.docs) {
              final task = TaskModel.fromSnapshot(taskDoc);
              if (!tasks.any((t) => t.id == task.id)) {
                tasks.add(task);
              }
            }

            tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            emit(AdminTasksLoadedState(tasks));
          });
        }
      }, onError: (error) {
        emit(AdminFailure(errorMessage: error.toString()));
      });
    } catch (error) {
      emit(AdminFailure(errorMessage: error.toString()));
    }
  }
  @override
  Future<void> close() {
    tasksSubscription?.cancel();
    return super.close();
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
      emit(AdminFailure(errorMessage: e.toString()));
    }
  }
}
