import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:task_mangment/admin/controller/admin_cubit.dart';
import 'package:task_mangment/core/routes/app_router.dart';
import 'package:task_mangment/core/routes/named_router.dart';
import 'package:task_mangment/shared_widgets/custom_appbar.dart';
import 'package:task_mangment/shared_widgets/custom_list.dart';
import 'package:task_mangment/shared_widgets/custom_shimmer.dart';
import 'package:task_mangment/shared_widgets/cutom_container.dart';
import 'package:task_mangment/user/auth_layer/controller/authentication_cubit.dart';

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
                  )
                : CustomListViewBuilder(
                    length: completedTasks.length,
                    stateTasks: completedTasks,
                    userId: '',
                  ),
          );
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
