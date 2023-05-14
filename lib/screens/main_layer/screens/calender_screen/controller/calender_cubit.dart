import 'package:bloc/bloc.dart';
import 'package:task_mangment/logic/calender_controller.dart';
import 'package:task_mangment/model/task_model.dart';

part 'calender_state.dart';

class CalenderCubit extends Cubit<CalenderState> {
  final String userId;
  final CalenderController calenderController;

  CalenderCubit({
    required this.userId,
    required this.calenderController,
  }) : super(CalenderState.initial());

  void fetchTasksForSelectedDay([DateTime? selectedDay]) async {
    selectedDay ??= state.selectedDay ?? DateTime.now();
    emit(state.copyWith(isLoading: true));
    try {
      final tasks =
          await CalenderController.getTasksForDay(selectedDay, userId);
      final groupedTasks = CalenderController.groupTasks(tasks);
      print(groupedTasks[selectedDay]);
      final selectedTasks = groupedTasks[selectedDay] ?? [];
      print(selectedTasks);

      if (selectedTasks == null) {
        print("Error: selectedTasks is null!");
      } else {
        print("Selected tasks:");
        for (var task in selectedTasks) {
          print(task.title);
        }
      }

      print('groupedTasks $groupedTasks');
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
