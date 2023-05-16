import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:task_mangment/user/main_layer/screens/home_screen/controller/task_cubit.dart';
import 'package:task_mangment/user/main_layer/screens/home_screen/controller/task_state.dart';
import 'package:task_mangment/user/main_layer/screens/home_screen/widgets/custom_sliver_appbar.dart';
import 'package:task_mangment/user/main_layer/screens/home_screen/widgets/custom_task_list.dart';
import 'package:task_mangment/shared_widgets/cutom_container.dart';
import 'package:task_mangment/utils/app_constants.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(

      builder: (context, state) {
        if (state is UserInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is UserLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is UserLoadedState) {
          final userData = state.user;
          final userTasks = state.tasks;
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                BuildSliverAppBar(
                  userName: userData.userName.toString(),
                  taskNumber: userTasks.length.toString(),
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    int todayTasksCount = userTasks.length;
                    int upcomingTasksCount = userTasks
                        .where((task) => task.state == 'upcoming')
                        .length;
                    int completedTasksCount = userTasks
                        .where((task) => task.state == 'completed')
                        .length;
                    switch (index) {
                      case 0:
                        return CustomContainer(
                          color: const Color(0xffF9B5D0),
                          title: 'Tasks',
                          taskNumber: todayTasksCount.toString(),
                        );
                      case 1:
                        return CustomContainer(
                          color: const Color(0xffC9F4AA),
                          title: 'Assigned',
                          taskNumber: upcomingTasksCount.toString(),
                        );
                      case 2:
                        return CustomContainer(
                          color: const Color(0xffF3CCFF),
                          title: 'Completed',
                          taskNumber: completedTasksCount.toString(),
                        );
                      default:
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child:
                          const CustomContainer(title: '', taskNumber: ''),
                        );
                    }
                  },
                  imageUrl: userData.profileImageUrl ?? '',
                  userId: userId,
                ),
              ];
            },
            body: TabBarView(
              children: [
                CustomTaskList(
                  userName: userData.userName,
                  state: 'today',
                  label: 'today',
                  userId: userId,
                  userCubit: BlocProvider.of<TaskCubit>(context),
                ),
                CustomTaskList(
                  userName: userData.userName,
                  state: 'upcoming',
                  label: 'Upcoming',
                  userId: userId,
                  userCubit: BlocProvider.of<TaskCubit>(context),
                ),
                CustomTaskList(
                  userName: userData.userName,
                  state: 'completed',
                  label: 'Completed',
                  userId: userId,
                  userCubit: BlocProvider.of<TaskCubit>(context),
                ),
              ],
            ),
          );
        } else if (state is UserConnectedState) {
          return const Center(
            child: CircularProgressIndicator(),
          ); // Show a loading indicator when the connection state is changing
        } else {
          return Center(
            child: Lottie.asset(
              ImageConstManger.noInternet,
              width: 200.w,
              height: 200.h,
            ),
          );
        }
      },

    );
  }
}
