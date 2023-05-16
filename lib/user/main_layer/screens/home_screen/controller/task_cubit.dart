import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:task_mangment/logic/firebase_controller.dart';
import 'package:task_mangment/model/task_model.dart';
import 'package:task_mangment/model/user_model.dart';
import 'package:task_mangment/user/main_layer/screens/home_screen/controller/task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final String userId;
  StreamSubscription<List<TaskModel>>? tasksSubscription;
  StreamSubscription<DocumentSnapshot>? userSubscription;
  DocumentReference? userDoc;

  bool isTaskCompleted = false;

  TaskCubit({required this.userId}) : super(UserInitial()) {
    userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    userSubscription = userDoc?.snapshots().listen((userData) async {
      try {
        final user = UserModel.fromSnapshot(userData);
        if (!userSubscription!.isPaused) {
          emit(UserLoadingState());
        }
        final tasksCollection = userDoc?.collection('tasks');
        if (tasksCollection != null) {
          final querySnapshot = await tasksCollection
              .orderBy('createdAt', descending: true)
              .get();
          final tasks = <TaskModel>[];
          for (var doc in querySnapshot.docs) {
            final task = TaskModel.fromSnapshot(doc);
            tasks.add(task);
          }
          tasksSubscription =
              FireBaseRepository.getUserTasksStream(userId: userId).listen(
            (tasks) {
              if (!tasksSubscription!.isPaused) {
                emit(UserLoadedState(user: user, tasks: tasks));
              }
            },
            onError: (error) {
              if (!tasksSubscription!.isPaused) {
                emit(UserErrorState(error: error.toString()));
              }
            },
          );
        }
      } catch (e) {
        if (!userSubscription!.isPaused) {
          emit(UserErrorState(error: e.toString()));
        }
      }
    });

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (!userSubscription!.isPaused) {
        switch (result) {
          case ConnectivityResult.wifi:
          case ConnectivityResult.mobile:
            _loadUserTasks();
            emit(UserConnectedState());
            break;
          case ConnectivityResult.none:
            emit(UserDisconnectedState());
            break;
          default:
            emit(UserErrorState(error: "Unknown connectivity state"));
            break;
        }
      }
    });
  }

  void changeTaskState(isDone) {
    isTaskCompleted = isDone;
    emit(ChangeTaskState(isTaskCompleted: isTaskCompleted));
  }

  void _loadUserTasks() async {
    // Cancel any active task subscription
    tasksSubscription?.cancel();

    // Get the user document
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

    try {
      final userSnapshot = await userDoc.get();
      final user = UserModel.fromSnapshot(userSnapshot);

      emit(UserLoadingState());

      // Get the tasks collection
      final tasksCollection = userDoc.collection('tasks');

      // Get the user's tasks from Firestore
      final querySnapshot =
          await tasksCollection.orderBy('createdAt', descending: true).get();

      final tasks =
          querySnapshot.docs.map((doc) => TaskModel.fromSnapshot(doc)).toList();

      // Subscribe to changes in the user's tasks
      tasksSubscription = tasksCollection
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => TaskModel.fromSnapshot(doc)).toList())
          .listen((tasks) {
        emit(UserLoadedState(user: user, tasks: tasks));
      }, onError: (error) {
        emit(UserErrorState(error: error.toString()));
      });

      emit(UserLoadedState(user: user, tasks: tasks));
    } catch (e) {
      emit(UserErrorState(error: e.toString()));
    }
  }

  Stream<List<TaskModel>> getUserTasksStream({required String userId}) {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    final tasksCollection = userDoc.collection('tasks');
    final snapshots =
        tasksCollection.orderBy('createdAt', descending: true).snapshots();
    return snapshots.map((querySnapshot) {
      final tasks = <TaskModel>[];
      for (var doc in querySnapshot.docs) {
        final task = TaskModel.fromSnapshot(doc);
        tasks.add(task);
      }
      return tasks;
    }).handleError((error) {
      // Handle any errors that occur when listening to the stream
      emit(UserErrorState(error: error.toString()));
    });
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
      emit(UserErrorState(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    userSubscription?.cancel();
    tasksSubscription?.cancel();
    return super.close();
  }
}
