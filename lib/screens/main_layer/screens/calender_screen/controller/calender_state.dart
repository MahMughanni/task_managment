part of 'calender_cubit.dart';

class CalenderState {
  final bool isLoading;
  final String? error;
  final List<TaskModel> tasks;
  final Map<DateTime, List<TaskModel>> groupedTasks;
  final List<TaskModel> selectedTasks;
  final DateTime? selectedDay; // <-- add this property

  CalenderState({
    required this.isLoading,
    this.error,
    required this.tasks,
    required this.groupedTasks,
    required this.selectedTasks,
    this.selectedDay, // <-- add this parameter
  });

  CalenderState.initial(): tasks = [],
        groupedTasks = {},
        selectedTasks = [],
        selectedDay = null,
        isLoading = false,
        error = null;

  CalenderState copyWith({
    List<TaskModel>? tasks,
    Map<DateTime, List<TaskModel>>? groupedTasks,
    List<TaskModel>? selectedTasks,
    DateTime? selectedDay,
    bool? isLoading,
    String? error,
  }) {
    selectedTasks ??= groupedTasks?[selectedDay ?? this.selectedDay] ?? [];
    return CalenderState(
      tasks: tasks ?? this.tasks,
      groupedTasks: groupedTasks ?? this.groupedTasks,
      selectedTasks: selectedTasks,
      selectedDay: selectedDay ?? this.selectedDay,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
