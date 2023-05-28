import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:task_management/admin/controller/admin_cubit.dart';
import 'package:task_management/core/routes/app_router.dart';
import 'package:task_management/core/routes/named_router.dart';
import 'package:task_management/user/main_layer/screens/home_screen/controller/task_cubit.dart';
import 'package:task_management/user/main_layer/screens/home_screen/controller/task_state.dart';
import 'package:task_management/user/main_layer/screens/home_screen/widgets/custom_sliver_appbar.dart';
import 'package:task_management/user/main_layer/screens/home_screen/widgets/custom_task_list.dart';
import 'package:task_management/shared_widgets/cutom_container.dart';
import 'package:task_management/utils/app_constants.dart';

class HomeScreenBody extends HookWidget {
  const HomeScreenBody({
    Key? key,
    required this.userId,
    required this.userRole,
    required this.userName,
  }) : super(key: key);

  final String userId, userRole, userName;

  @override
  Widget build(BuildContext context) {
    final adminCubit = BlocProvider.of<AdminCubit>(context);
    useEffect(() {
      adminCubit.fetchAllTasks();
      return () {
        //clean if needed
      };
    }, []);

    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        if (state is AdminInitial || state is AdminLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is AdminTasksLoadedState) {
          final userTasks = state.tasks;
          final upcomingTasksCount =
              userTasks.where((task) => task.state == 'upcoming').length;
          final completedTasksCount =
              userTasks.where((task) => task.state == 'completed').length;

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                BuildSliverAppBar(
                  userName: userName,
                  taskNumber: userTasks.length.toString(),
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    int todayTasksCount = userTasks.length;
                    // int upcomingTasksCount = userTasks.where((task) => task.state == 'upcoming').length;
                    // int completedTasksCount = userTasks.where((task) => task.state == 'completed').length;
                    switch (index) {
                      case 0:
                        return CustomContainer(
                          color: const Color(0xffF9B5D0),
                          title: 'Tasks',
                          taskNumber: todayTasksCount.toString(),
                          onTap: () {
                            AppRouter.goTo(
                              screenName: NamedRouter.userDetailsStatusTasks,
                              arguments: {
                                'status': 'today',
                                'userId': userId,
                                'role': userRole,
                              },
                            );
                          },
                        );
                      case 1:
                        return CustomContainer(
                          color: const Color(0xffC9F4AA),
                          title: 'Assigned',
                          taskNumber: upcomingTasksCount.toString(),
                          onTap: () {
                            AppRouter.goTo(
                              screenName: NamedRouter.userDetailsStatusTasks,
                              arguments: {
                                'status': 'upcoming',
                                'userId': userId,
                                'role': userRole,
                              },
                            );
                          },
                        );
                      case 2:
                        return CustomContainer(
                          color: const Color(0xffF3CCFF),
                          title: 'Completed',
                          taskNumber: completedTasksCount.toString(),
                          onTap: () {
                            AppRouter.goTo(
                              screenName: NamedRouter.userDetailsStatusTasks,
                              arguments: {
                                'status': 'completed',
                                'userId': userId,
                                'role': userRole,
                              },
                            );
                          },
                        );
                      default:
                        return const Center(
                          child: Text('No Tasks'),
                        );
                    }
                  },
                  imageUrl: '',
                  userId: userId,
                  userRole: userRole,
                )
              ];
            },
            body: TabBarView(
              children: [
                CustomTaskList(
                  userName: '',
                  state: 'today',
                  label: 'today',
                  userId: userId,
                  adminCubit: adminCubit,
                  taskType: 'today',
                ),
                CustomTaskList(
                  userName: 'Admin',
                  state: 'upcoming',
                  label: 'Upcoming',
                  userId: userId,
                  adminCubit: adminCubit,
                  taskType: 'upcoming',
                ),
                CustomTaskList(
                  userName: 'Admin',
                  state: 'completed',
                  label: 'Completed',
                  userId: userId,
                  adminCubit: adminCubit,
                  taskType: 'completed',
                ),
              ],
            ),
          );
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
