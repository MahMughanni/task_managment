import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/controller/task_cubit.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/controller/task_state.dart';
import 'package:task_mangment/screens/main_layer/screens/task_details_screen/task_details_screen.dart';
import 'package:task_mangment/shared_widgets/custom_shimmer.dart';
import 'package:task_mangment/shared_widgets/list_item_body.dart';
import 'package:task_mangment/utils/app_constants.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class CustomTaskList extends StatelessWidget {
  const CustomTaskList({
    Key? key,
    required this.state,
    required this.label,
    required this.userName,
    required this.userId,
    this.userCubit,
  }) : super(key: key);

  final String state;
  final String label;
  final String? userName;
  final String userId;
  final TaskCubit? userCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state is UserLoadingState) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: 15,
              itemBuilder: (context, index) => const ShimmerListViewItemBody());
        }
        if (state is UserErrorState) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: 15,
              itemBuilder: (context, index) => const ShimmerListViewItemBody());
        }
        if (state is UserLoadedState) {
          final tasks = state.tasks;
          final stateTasks =
              tasks.where((task) => task.state == this.state).toList();
          return stateTasks.isNotEmpty
              ? Column(
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: AppConstFontWeight.medium,
                          color: Colors.blueAccent,
                          fontSize: 12.sp),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: stateTasks.length,
                        itemBuilder: (context, index) => GestureDetector(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "Delete task?",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        "Cancel",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        "Delete",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        final task = stateTasks[index];
                                        userCubit?.deleteTask(
                                            userId: userId, id: task.id!);
                                        Navigator.of(context).pop();
                                      },
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
                                  task: stateTasks[index],
                                  userName: userName ?? '',
                                  userId: userId,
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
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: 15,
                  itemBuilder: (context, index) =>
                      const ShimmerListViewItemBody());
        }
        return ListView.builder(
            shrinkWrap: true,
            itemCount: 15,
            itemBuilder: (context, index) =>
                const ShimmerListViewItemBody()); // default return
      },
    );
  }
}
