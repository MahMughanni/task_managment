import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_management/model/task_model.dart';


class CalendarController {
  static Future<List<TaskModel>> getTasksForDay(DateTime day, String userId) async {
    final startOfDay = DateTime.utc(day.year, day.month, day.day);
    final endOfDay = startOfDay
        .add(const Duration(days: 1))
        .subtract(const Duration(milliseconds: 1));

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .where('createdAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .get();

    final tasks =
        snapshot.docs.map((doc) => TaskModel.fromSnapshot(doc)).toList();
    return tasks;
  }

  static Map<DateTime, List<TaskModel>> groupTasks(List<TaskModel> tasks) {
    return tasks.fold({}, (map, task) {
      final taskDate = task.createdAt.toDate();
      final date = DateTime.utc(taskDate.year, taskDate.month, taskDate.day);
      if (map[date] == null) {
        map[date] = [task];
      } else {
        map[date]!.add(task);
      }
      return map;
    });
  }

}
