import 'package:flutter/material.dart';
import 'package:task_mangment/core/logic/base_cubit.dart';
import 'package:task_mangment/model/task_model.dart';
import 'package:task_mangment/shared_widgets/list_item_body.dart';
import 'package:task_mangment/user/main_layer/screens/task_details_screen/task_details_screen.dart';

class CustomListViewBuilder extends StatelessWidget {
  CustomListViewBuilder({
    Key? key,
    required this.length,
    required this.stateTasks,
    required this.userId,
  }) : super(key: key);

  final int length;
  final List<TaskModel> stateTasks;
  final String userId;

  final BaseCubit baseCubit = BaseCubit();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: length,
      itemBuilder: (context, index) {
        if (index >= stateTasks.length) {
          return Container();
        }
        final task = stateTasks[index];

        print('Task UserName${task.userName}');


        return GestureDetector(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    "Delete task?",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  actions: [
                    TextButton(
                      child: Text(
                        "Cancel",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        baseCubit.deleteTask(userId: userId, id: task.id!);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Delete",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailsScreen(
                  task: task,
                  userName: task.userName,
                  userId: userId,
                ),
              ),
            );
          },
          child: ListViewItemBody(
            title: task.description,
            startTime: task.startTime,
            taskTitle: task.title,
            taskCategory: task.state,
            url: task.imageUrls.isNotEmpty ? task.imageUrls.first : '',
            status: task.state,
            userName: task.userName,
          ),
        );
      },
    );
  }
}
