import 'package:flutter/material.dart';
import '../../../../../model/task_model.dart';
import '../../../../../shared_widgets/list_item_body.dart';
import '../../../../../utils/UtilsConfig.dart';

class CustomTaskList extends StatelessWidget {
  const CustomTaskList(
      {Key? key,
      required this.state,
      required this.label,
      required this.userTask})
      : super(key: key);
  final String state;

  final String label;

  final dynamic userTask;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TaskModel>>(
      future: userTask,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final tasks = snapshot.data!;
        final stateTasks = tasks.where((task) => task.state == state).toList();
        return stateTasks.isNotEmpty
            ? Column(
                children: [
                  Text(
                    label,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.blueAccent),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: stateTasks.length,
                      itemBuilder: (context, index) => ListViewItemBody(
                        title: stateTasks[index].description,
                        startTime:
                            UtilsConfig.formatTime(stateTasks[index].startTime)
                                .toString(),
                        userName: stateTasks[index].title,
                        taskCategory: stateTasks[index].state,
                        // endTime: stateTasks[index].endTime,
                      ),
                    ),
                  ),
                ],
              )
            : Container();
      },
    );
  }
}
