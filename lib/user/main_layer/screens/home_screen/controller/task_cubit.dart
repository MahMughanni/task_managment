import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:task_mangment/model/task_model.dart';
import 'package:task_mangment/model/user_model.dart';
import 'package:task_mangment/user/main_layer/screens/home_screen/controller/task_state.dart';

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
        final user = UserModel.fromSnapshot(userData);
        if (!isClosed) {
          emit(UserLoadingState());
        }
        await _loadUserTasks(user);
      } catch (e) {
        if (!isClosed) {
          emit(UserErrorState(error: e.toString()));
        }
      }
    });

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (!isClosed) {
        switch (result) {
          case ConnectivityResult.wifi:
          case ConnectivityResult.mobile:
            _loadUserTasks(null);
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

  void changeTaskState(bool isDone) {
    isTaskCompleted = isDone;
    if (!isClosed) {
      emit(ChangeTaskState(isTaskCompleted: isTaskCompleted));
    }
  }

  Future<void> loadUserTasks(String userId) async {
    // Cancel any active task subscription
    tasksSubscription?.cancel();

    try {
      // Get the user document reference
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      if (!isClosed) {
        emit(UserLoadingState());
      }

      // Get the tasks collection for the user
      final tasksCollection = userDoc.collection('tasks');

      // Get the user's tasks from Firestore and order them by createdAt field
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
        if (!isClosed) {
          emit(UserLoadedState(user: user!, tasks: tasks));
        }
      }, onError: (error) {
        if (!isClosed) {
          emit(UserErrorState(error: error.toString()));
        }
      });

      // Sort the tasks in descending order (newest to oldest)
      tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      if (!isClosed) {
        emit(UserLoadedState(user: user!, tasks: tasks));
      }
    } catch (e) {
      if (!isClosed) {
        emit(UserErrorState(error: e.toString()));
      }
    }
  }

  Future<void> _loadUserTasks(user) async {
    // Cancel any active task subscription
    tasksSubscription?.cancel();

    try {
      if (user == null) {
        final userSnapshot = await userDoc!.get();
        user = UserModel.fromSnapshot(userSnapshot);
      }

      if (!isClosed) {
        emit(UserLoadingState());
      }

      // Get the tasks collection
      final tasksCollection = userDoc!.collection('tasks');

      // Get the user's tasks from Firestore and order them by createdAt field
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
        if (!isClosed) {
          emit(UserLoadedState(user: user!, tasks: tasks));
        }
      }, onError: (error) {
        if (!isClosed) {
          emit(UserErrorState(error: error.toString()));
        }
      });

      // Sort the tasks in descending order (newest to oldest)
      tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      if (!isClosed) {
        emit(UserLoadedState(user: user, tasks: tasks));
      }
    } catch (e) {
      if (!isClosed) {
        emit(UserErrorState(error: e.toString()));
      }
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
