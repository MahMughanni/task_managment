import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../model/task_model.dart';
import '../../../../../shared_widgets/list_item_body.dart';
import '../../task_details_screen/task_details_screen.dart';

class CustomTaskList extends StatelessWidget {
  const CustomTaskList({
    Key? key,
    required this.state,
    required this.label,
    required this.userTask,
    this.userName,
  }) : super(key: key);
  final String state;

  final String label;
  final String? userName;

  final dynamic userTask;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TaskModel>>(
      stream: userTask,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
              baseColor: Colors.grey[350]!,
              highlightColor: Colors.grey[200]!,
              child: const ListViewItemBody(
                title: '',
                startTime: '',
                userName: '',
                taskCategory: '',
                url: '',
                // endTime: stateTasks[index].endTime,
              ));
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
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailsScreen(
                                task: stateTasks[index],
                                userName: userName ?? '',
                              ),
                            ),
                          );
                        },
                        child: ListViewItemBody(
                            title: stateTasks[index].description,
                            startTime: stateTasks[index].startTime,
                            userName: stateTasks[index].title,
                            taskCategory: stateTasks[index].state,
                            url: stateTasks[index].imageUrls.isNotEmpty
                                ? stateTasks[index].imageUrls.first
                                : ''),
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
