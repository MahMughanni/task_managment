part of 'project_cubit.dart';

@immutable
abstract class ProjectState {}

class ProjectInitial extends ProjectState {}

class ProjectLoadedState extends ProjectState {
  final List<ProjectModel> projects;

  ProjectLoadedState({required this.projects});
}

class ProjectFailure extends ProjectState {
  final Object? error;
  final Object? stackTrace;

  ProjectFailure({required this.error, this.stackTrace});

  @override
  String toString() {
    return 'ProjectFailure{error: $error}';
  }
}
class UserLoadingState extends ProjectState {}

class ProjectsLoadingState extends ProjectState {
  @override
  String toString() {
    return 'ProjectsLoadingState';
  }
}
