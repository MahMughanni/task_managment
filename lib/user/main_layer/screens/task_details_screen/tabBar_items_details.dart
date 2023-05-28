import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/admin/controller/admin_cubit.dart';
import 'package:task_management/shared_widgets/custom_appbar.dart';
import 'package:task_management/shared_widgets/custom_list.dart';
import 'package:task_management/shared_widgets/custom_shimmer.dart';
import 'package:task_management/user/main_layer/screens/home_screen/controller/task_cubit.dart';
import 'package:task_management/user/main_layer/screens/home_screen/controller/task_state.dart';

class UserDetailsStatusTasks extends StatelessWidget {
  const UserDetailsStatusTasks(
      {Key? key,
      required this.status,
      required this.userId,
      required this.role})
      : super(key: key);
  final String status, userId, role;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        if (state is AdminTasksLoadedState) {
          final user = state.user;
          final tasks = state.tasks;
          var upcomingTasks =
              tasks.where((task) => task.state == 'upcoming').toList();
          var completedTasks =
              tasks.where((task) => task.state == 'completed').toList();
          return Scaffold(
            appBar: CustomAppbar(
              title: status == 'upcoming'
                  ? 'Assigned Tasks'
                  : status == 'completed'
                      ? 'Completed Tasks'
                      : 'All Tasks',
              action: const [],
            ),
            body: status == 'upcoming'
                ? CustomListViewBuilder(
                    length: upcomingTasks.length,
                    stateTasks: upcomingTasks,
                    userId: user?.uId ?? '',
                    role: role,
                  )
                : status == 'completed'
                    ? CustomListViewBuilder(
                        length: completedTasks.length,
                        stateTasks: completedTasks,
                        userId: user?.uId ?? '',
                        role: role,
                      )
                    : CustomListViewBuilder(
                        length: tasks.length,
                        stateTasks: tasks,
                        userId: user?.uId ?? '',
                        role: role,
                      ),
          );
        } else {
          return Scaffold(
            appBar: CustomAppbar(
              title:
                  status == 'upcoming' ? 'Assigned Tasks' : 'Completed Tasks',
              action: const [],
            ),
            body: ListView.builder(
              shrinkWrap: true,
              itemCount: 7,
              itemBuilder: (context, index) => const ShimmerListViewItemBody(),
            ),
          );
        }
      },
    );
  }
}
