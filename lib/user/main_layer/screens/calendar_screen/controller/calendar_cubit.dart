import 'package:bloc/bloc.dart';
import 'package:task_management/core/logic/calender_controller.dart';
import 'package:task_management/model/task_model.dart';

part 'calendar_state.dart';

class CalenderCubit extends Cubit<CalenderState> {
  final String userId;
  final CalendarController calenderController;

  CalenderCubit({
    required this.userId,
    required this.calenderController,
  }) : super(CalenderState.initial());

  void fetchTasksForSelectedDay([DateTime? selectedDay]) async {
    selectedDay ??= state.selectedDay ?? DateTime.now();
    emit(state.copyWith(isLoading: true));
    try {
      final tasks =
          await CalendarController.getTasksForDay(selectedDay, userId);
      final groupedTasks = CalendarController.groupTasks(tasks);
      final selectedTasks = groupedTasks[selectedDay] ?? [];

      emit(state.copyWith(
        isLoading: false,
        tasks: tasks,
        groupedTasks: groupedTasks,
        selectedTasks: selectedTasks,
        selectedDay: selectedDay,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
        selectedTasks: [],
      ));
    }
  }

  void onDaySelected(DateTime selectedDay) {
    emit(state.copyWith(selectedDay: selectedDay));
    fetchTasksForSelectedDay(selectedDay);
  }

  void init() {
    fetchTasksForSelectedDay();
  }
}
