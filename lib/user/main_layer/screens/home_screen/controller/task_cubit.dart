import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:task_management/model/task_model.dart';
import 'package:task_management/model/user_model.dart';
import 'package:task_management/user/main_layer/screens/home_screen/controller/task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final String userId;
  StreamSubscription<List<TaskModel>>? tasksSubscription;
  StreamSubscription<DocumentSnapshot>? userSubscription;
  DocumentReference? userDoc;
  bool isTaskCompleted = false;
  UserModel? user;

  TaskCubit({required this.userId}) : super(UserInitial()) {
    userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    userSubscription = userDoc?.snapshots().listen((userData) async {
      try {
        user = UserModel.fromSnapshot(userData);
        if (!isClosed) {
          emit(UserLoadingState());
        }
        await fetchAllTasks();
      } catch (e) {
        if (!isClosed) {
          emit(Failure(errorMessage: e.toString()));
        }
      }
    });

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (!isClosed) {
        switch (result) {
          case ConnectivityResult.wifi:
          case ConnectivityResult.mobile:
            emit(UserConnectedState());
            break;
          case ConnectivityResult.none:
            emit(UserDisconnectedState());
            break;
          default:
            emit(Failure(errorMessage: "Unknown connectivity state"));
            break;
        }
      }
    });
  }

  void changeTaskState(bool isDone) {
    isTaskCompleted = isDone;
    if (!isClosed) {
      emit(ChangeTaskState(isTaskCompleted: isTaskCompleted));
    }
  }

  Future<void> fetchAllTasks() async {
    try {
      emit(UserLoadingState());

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

            print('Cubit UserName : ${user!.userName!}');
            emit(UserLoadedState(user: user!, tasks: allTasks));
          });
        }
      }, onError: (error) {
        emit(Failure(errorMessage: error.toString()));
      }) as StreamSubscription<List<TaskModel>>?;
    } catch (error) {
      emit(Failure(errorMessage: error.toString()));
    }
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
      emit(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    userSubscription?.cancel();
    tasksSubscription?.cancel();
    return super.close();
  }
}
