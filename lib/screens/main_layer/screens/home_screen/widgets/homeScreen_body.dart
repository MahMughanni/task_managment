import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/controller/user_cubit.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/controller/user_state.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/widgets/custom_sliver_appbar.dart';
import 'package:task_mangment/screens/main_layer/screens/home_screen/widgets/custom_task_list.dart';
import 'package:task_mangment/shared_widgets/custom_shimmer.dart';
import 'package:task_mangment/shared_widgets/cutom_container.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, HomeState>(
      builder: (context, state) {
        if (state is UserLoadedState) {
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
                  userCubit: BlocProvider.of<UserCubit>(context),
                ),
                CustomTaskList(
                  userName: userData.userName,
                  state: 'upcoming',
                  label: 'Upcoming',
                  userId: userId,
                  userCubit: BlocProvider.of<UserCubit>(context),
                ),
                CustomTaskList(
                  userName: userData.userName,
                  state: 'completed',
                  label: 'Completed',
                  userId: userId,
                  userCubit: BlocProvider.of<UserCubit>(context),
                ),
              ],
            ),
          );
        } else if (state is UserErrorState) {
          return Text('Error: ${state.error}');
        } else {
          // Handle other states (e.g. UserInitial)
          return ListView.builder(
              shrinkWrap: true,
              itemCount: 15,
              itemBuilder: (context, index) => const ShimmerListViewItemBody());
        }
      },
    );
  }
}
