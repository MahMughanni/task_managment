import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/admin/controller/admin_cubit.dart';

import 'package:task_management/shared_widgets/custom_appbar.dart';
import 'package:task_management/shared_widgets/custom_list.dart';
import 'package:task_management/shared_widgets/custom_shimmer.dart';

class AdminDetailsStatusTasks extends StatelessWidget {
  const AdminDetailsStatusTasks({Key? key, required this.status})
      : super(key: key);

  final String status;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        if (state is AdminTasksLoadedState) {
          var tasks = state.tasks;
          var user = state.user;
          var upcomingTasks =
              tasks.where((task) => task.state == 'upcoming').toList();
          var completedTasks =
              tasks.where((task) => task.state == 'completed').toList();
          if ((status == 'upcoming' && upcomingTasks.isEmpty) ||
              (status == 'completed' && completedTasks.isEmpty)) {
            return Scaffold(
              appBar: CustomAppbar(
                title:
                    status == 'upcoming' ? 'Assigned Tasks' : 'Completed Tasks',
                action: const [],
              ),
              body: const Center(
                child: Text('No Tasks .. !'),
              ),
            );
          } else if (status == 'upcoming' || upcomingTasks.isNotEmpty) {
            return Scaffold(
              appBar: const CustomAppbar(
                title: 'Assigned Tasks',
                action: [],
              ),
              body: CustomListViewBuilder(
                length: upcomingTasks.length,
                stateTasks: upcomingTasks,
                userId: user?.uId ?? '',
                role: user?.role ?? 'admin',
                userName: user?.userName ?? '',
              ),
            );
          } else if (status == 'completed' || completedTasks.isNotEmpty) {
            return Scaffold(
              appBar: const CustomAppbar(
                title: 'Completed Tasks',
                action: [],
              ),
              body: CustomListViewBuilder(
                length: completedTasks.length,
                stateTasks: completedTasks,
                userId: user?.uId ?? '',
                role: user?.role ?? 'admin',
                userName: user?.userName ?? '',
              ),
            );
          }
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: 7,
          itemBuilder: (context, index) => const ShimmerListViewItemBody(),
        );
      },
    );
  }
}
