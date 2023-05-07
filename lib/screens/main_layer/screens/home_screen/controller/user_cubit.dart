import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_mangment/logic/firebase_controller.dart';
import 'package:task_mangment/model/task_model.dart';
import 'package:task_mangment/model/user_model.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/controller/user_state.dart';

class UserCubit extends Cubit<HomeState> {
  final String userId;
  late StreamSubscription<List<TaskModel>> tasksSubscription;
  late StreamSubscription<DocumentSnapshot> userSubscription;

  UserCubit(this.userId) : super(UserInitial()) {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    userSubscription = userDoc.snapshots().listen((userData) async {
      try {
        final user = UserModel.fromSnapshot(userData);
        emit(UserLoadingState());

        final tasksCollection = userDoc.collection('tasks');
        final querySnapshot =
        await tasksCollection.orderBy('createdAt', descending: true).get();

        final tasks = <TaskModel>[];
        for (var doc in querySnapshot.docs) {
          final task = TaskModel.fromSnapshot(doc);
          tasks.add(task);
        }

        tasksSubscription = FireBaseRepository.getUserTasksStream(userId: userId)
            .listen((tasks) {
          emit(UserLoadedState(user: user, tasks: tasks));
        }, onError: (error) {
          emit(UserErrorState(error: error.toString()));
        });
      } catch (e) {
        emit(UserErrorState(error: e.toString()));
      }
    });
  }

   getUserTasksStream({required String userId}) {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    final tasksCollection = userDoc.collection('tasks');
    final snapshots = tasksCollection.orderBy('createdAt', descending: true).snapshots();
    return snapshots.map((querySnapshot) {
      final tasks = <TaskModel>[];
      for (var doc in querySnapshot.docs) {
        final task = TaskModel.fromSnapshot(doc);
        tasks.add(task);
      }
      return tasks;
    });
  }

  @override
  Future<void> close() {
    tasksSubscription.cancel();
    userSubscription.cancel();
    return super.close();
  }
}
