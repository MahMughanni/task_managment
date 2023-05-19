import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_mangment/admin/controller/admin_cubit.dart';
import 'package:task_mangment/shared_widgets/custom_list.dart';
import 'package:task_mangment/user/main_layer/screens/home_screen/controller/task_cubit.dart';
import 'package:task_mangment/user/main_layer/screens/home_screen/controller/task_state.dart';
import 'package:task_mangment/shared_widgets/custom_shimmer.dart';
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
    this.adminCubit,
    required this.taskType,
  }) : super(key: key);

  final String state;
  final String taskType; // Add this parameter
  final String label;
  final String? userName;
  final String userId;
  final TaskCubit? userCubit;
  final AdminCubit? adminCubit;

  @override
  Widget build(BuildContext context) {
    if (userCubit != null) {
      return BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is UserLoadingState) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: 15,
              itemBuilder: (context, index) => const ShimmerListViewItemBody(),
            );
          }
          if (state is UserErrorState) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: 15,
              itemBuilder: (context, index) => const ShimmerListViewItemBody(),
            );
          }
          if (state is UserLoadedState) {
            final tasks = state.tasks;
            final stateTasks = tasks.where((task) {
              final taskDateTime = task.createdAt.toDate();
              final formattedTaskDate = DateTime(
                  taskDateTime.year, taskDateTime.month, taskDateTime.day);
              final today = DateTime.now();
              return (task.state == this.state && taskType != 'today') ||
                  (task.state == this.state &&
                      taskType == 'today' &&
                      formattedTaskDate.year == today.year &&
                      formattedTaskDate.month == today.month &&
                      formattedTaskDate.day == today.day);
            }).toList();
            return stateTasks.isNotEmpty
                ? Column(
                    children: [
                      Text(
                        label,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: AppConstFontWeight.medium,
                                  color: Colors.blueAccent,
                                  fontSize: 12.sp,
                                ),
                      ),
                      Expanded(
                        child: CustomListViewBuilder(
                          length: stateTasks.length,
                          userId: userId,
                          stateTasks: stateTasks,
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: 15,
                    itemBuilder: (context, index) =>
                        const ShimmerListViewItemBody(),
                  );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: 15,
            itemBuilder: (context, index) => const ShimmerListViewItemBody(),
          ); // default return
        },
      );
    } else if (adminCubit != null) {
      return BlocBuilder<AdminCubit, AdminState>(
        builder: (context, state) {
          if (state is AdminLoadingState) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) => const ShimmerListViewItemBody(),
            );
          }
          if (state is AdminFailure) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) => const ShimmerListViewItemBody(),
            );
          }
          if (state is AdminTasksLoadedState) {
            final tasks = state.tasks;
            final stateTasks = tasks.where((task) {
              final taskDateTime = task.createdAt.toDate();
              final formattedTaskDate = DateTime(
                  taskDateTime.year, taskDateTime.month, taskDateTime.day);
              final today = DateTime.now();
              return (task.state == this.state && taskType != 'today') ||
                  (task.state == this.state &&
                      taskType == 'today' &&
                      formattedTaskDate.year == today.year &&
                      formattedTaskDate.month == today.month &&
                      formattedTaskDate.day == today.day);
            }).toList();
            return stateTasks.isNotEmpty
                ? Column(
                    children: [
                      Text(
                        label,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: AppConstFontWeight.medium,
                                  color: Colors.blueAccent,
                                  fontSize: 12.sp,
                                ),
                      ),
                      Expanded(
                        child: CustomListViewBuilder(
                          length: stateTasks.length,
                          userId: userId,
                          stateTasks: stateTasks,
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: 15,
                    itemBuilder: (context, index) =>
                        const ShimmerListViewItemBody(),
                  );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: 15,
            itemBuilder: (context, index) => const ShimmerListViewItemBody(),
          ); // default return
        },
      );
    } else {
      return const SizedBox(); // Return an empty widget if both cubits are null
    }
  }
}
