import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/task_model.dart';

class CalenderController {
  static Future<List<TaskModel>> getTasksForDay(DateTime day, String userId) async {
    final startOfDay = DateTime.utc(day.year, day.month, day.day);
    final endOfDay = startOfDay
        .add(const Duration(days: 1))
        .subtract(const Duration(milliseconds: 1));

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .get();

    final tasks =
        snapshot.docs.map((doc) => TaskModel.fromSnapshot(doc)).toList();
    return tasks;
  }

  static Map<DateTime, List<TaskModel>> groupTasks2(List<TaskModel> tasks) {
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

  static Map<DateTime, List<TaskModel>> groupTasks(List<TaskModel> tasks) {
    final groupedTasks = <DateTime, List<TaskModel>>{};
    for (var task in tasks) {
      final date = DateTime(
        task.createdAt.toDate().year,
        task.createdAt.toDate().month,
        task.createdAt.toDate().day,
      );
      if (groupedTasks.containsKey(date)) {
        groupedTasks[date]!.add(task);
      } else {
        groupedTasks[date] = [task];
      }
    }
    return groupedTasks;
  }

  static Stream<List<TaskModel>> getUserTasksByDateToCalender(
      {required String userId}) {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    final tasksCollection = userDoc.collection('tasks');
    return tasksCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
        .map((doc) => TaskModel.fromSnapshot(doc))
        .toList());
  }

}
