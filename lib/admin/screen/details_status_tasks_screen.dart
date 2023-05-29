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
          return Scaffold(
              appBar: CustomAppbar(
                title:
                    status == 'upcoming' ? 'Assigned Tasks' : 'Completed Tasks',
                action: const [],
              ),
              body: status == 'upcoming'
                  ? CustomListViewBuilder(
                      length: upcomingTasks.length,
                      stateTasks: upcomingTasks,
                      userId: '',
                      role: 'admin',
                      userName: '',
                    )
                  : status == 'completed'
                      ? CustomListViewBuilder(
                          length: completedTasks.length,
                          stateTasks: completedTasks,
                          userId: '',
                          role: 'admin',
                          userName: '',
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: 7,
                          itemBuilder: (context, index) =>
                              const ShimmerListViewItemBody(),
                        ));
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: 7,
            itemBuilder: (context, index) => const ShimmerListViewItemBody(),
          );
        }
      },
    );
  }
}
