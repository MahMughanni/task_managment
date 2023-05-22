import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:task_management/core/logic/firebase_controller.dart';
import 'package:task_management/model/task_model.dart';
import 'package:task_management/model/user_model.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit() : super(AdminInitial());

  StreamSubscription<QuerySnapshot>? tasksSubscription;
  StreamSubscription<DocumentSnapshot>? userSubscription;

  Future<void> fetchAllTasks() async {
    try {
      emit(AdminLoadingState());

      final usersCollection = FirebaseFirestore.instance.collection('users');
      final snapshots = usersCollection.snapshots();

      final tasksMap = <String, List<TaskModel>>{};

      tasksSubscription = snapshots.listen((querySnapshot) {
        for (var userDoc in querySnapshot.docs) {
          final userId = userDoc.id;
          final tasksCollection = userDoc.reference.collection('tasks');

          tasksCollection
              .orderBy('createdAt', descending: true)
              .snapshots()
              .listen((taskSnapshot) {
            final tasks = <TaskModel>[];

            for (var taskDoc in taskSnapshot.docs) {
              final task = TaskModel.fromSnapshot(taskDoc);
              tasks.add(task);
            }

            tasksMap[userId] = tasks;
            final allTasks = tasksMap.values.expand((tasks) => tasks).toList();
            allTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            emit(AdminTasksLoadedState(allTasks));
          });
        }
      }, onError: (error) {
        emit(AdminFailure(errorMessage: error.toString()));
      });
    } catch (error) {
      emit(AdminFailure(errorMessage: error.toString()));
    }
  }

  void getTasksForUser(String userId) async {
    emit(AdminLoadingState());

    try {
      // Call your task repository or API to fetch tasks for the user
      final tasks = await FireBaseRepository().getTasksForUser(userId, 'user');

      // Emit the tasks loaded state with the fetched tasks
      emit(AdminTasksLoadedState(tasks));
    } catch (error) {
      // Handle any error that occurred during the fetching process
      emit(AdminFailure(errorMessage: error.toString()));
    }
  }


  @override
  Future<void> close() {
    tasksSubscription?.cancel();
    userSubscription?.cancel();
    return super.close();
  }
}
