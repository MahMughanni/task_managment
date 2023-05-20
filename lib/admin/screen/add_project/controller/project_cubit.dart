import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:task_mangment/model/project_model.dart';
import 'package:task_mangment/model/user_model.dart';

part 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  StreamSubscription<List<ProjectModel>>? projectsSubscription;
  StreamSubscription<DocumentSnapshot>? userSubscription;

  User? user = FirebaseAuth.instance.currentUser;

  DocumentReference? userDoc;

  ProjectCubit() : super(ProjectInitial()) {
    userDoc = FirebaseFirestore.instance.collection('users').doc(user!.uid);
    userSubscription = userDoc?.snapshots().listen((userData) async {
      try {
        final user = UserModel.fromSnapshot(userData);
        if (!isClosed) {
          emit(UserLoadingState());
        }
        await loadProjects(user);
      } catch (e) {
        if (!isClosed) {
          emit(ProjectFailure(error: e.toString()));
        }
      }
    });
  }

  Future<void> loadProjects(user) async {
    projectsSubscription?.cancel();
    try {
      if (user == null) {
        final userSnapshot = await userDoc!.get();
        user = ProjectModel.fromSnapshot(userSnapshot);
      }

      if (!isClosed) {
        emit(ProjectsLoadingState());
      }
      final tasksCollection = userDoc!.collection('projects');
      final querySnapshot =
          await tasksCollection.orderBy('createdAt', descending: true).get();

      final tasks = querySnapshot.docs
          .map((doc) => ProjectModel.fromSnapshot(doc))
          .toList();
      projectsSubscription = tasksCollection
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ProjectModel.fromSnapshot(doc))
              .toList())
          .listen((tasks) {
        if (!isClosed) {
          emit(ProjectLoadedState(projects: tasks));
        }
      }, onError: (error) {
        if (!isClosed) {
          emit(ProjectFailure(error: error.toString()));
        }
      });

      // Sort the tasks in descending order (newest to oldest)
      tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      if (!isClosed) {
        emit(ProjectLoadedState(projects: tasks));
      }
    } catch (e) {
      if (!isClosed) {
        emit(ProjectFailure(error: e.toString()));
      }
    }
  }

  @override
  Future<void> close() {
    projectsSubscription?.cancel();
    return super.close();
  }
}
